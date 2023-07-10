---
layout: post
title: Scripting automate new jekyll-Pposts
date: 2023-07-08 00:00:00 +0100
categories: [Programming, Scripting]
tags: [servers,nginx,webserver,jekyll,automation,scripting,shell,bash]
author: "Christian Strube"
image:
  path: https://images.cstrube.de/uploads/original/89/bd/b33eca3371ad2efec9085ca295ca.webp
  lqip: data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBAQFBAYFBQYJBgUGCQsIBgYICwwKCgsKCgwQDAwMDAwMEAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/2wBDAQcHBw0MDRgQEBgUDg4OFBQODg4OFBEMDAwMDBERDAwMDAwMEQwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAPABQDAREAAhEBAxEB/8QAGAAAAgMAAAAAAAAAAAAAAAAAAgMEBgf/xAArEAABAwMBAw0AAAAAAAAAAAACARESAAMEIQUxUQYTFSIjM0FTYnGCodH/xAAYAQEAAwEAAAAAAAAAAAAAAAACAAMEAf/EACQRAAEDAgQHAAAAAAAAAAAAAAEAAhEDEgQiUWETIUFSkrLi/9oADAMBAAIRAxEAPwDL8jbmZiLbW1klbt3EIU3aKK6u4lxrokkgIVC1oBIm5KLlnti2CAOQpiSusVD76lMMdqqDiGaHy+VK6ay25yfbThL1Si8dz0J5StVuaN1Xci4tyzaHJtmAgpwJ0R3XXfwqCQTCFVrXAXGIlDbDCTzF+QflMOfoqODS7vVFPIk0C76Tv4zePvVfRbJzTuv/2Q==
---
This script aims to automate the process of creating a new blog post in Jekyll, specifically optimizing images and generating their associated Base64 Low Quality Image Placeholders (LQIP).

Here's an overview of the script and its functions:

**1. Preparation:**
Initially, the script defines necessary directories and ensures they exist. It creates them if they don't exist.

**2. Directory Monitoring:**
It uses `inotifywait` to monitor the directory where new images are uploaded for new files. It responds to "create" and "moved_to" events and processes every new `.jpg` file added to the directory.

**3. Post Creation:**
For each uploaded image, a new blog post is created based on the image's directory name. The script generates a Jekyll-compatible markdown file with metadata like title, date, categories, tags, and author. It also creates a special `image` metadata field that contains the path to the image file and the Base64 string of the LQIP.

**4. Image Optimization:**
Each image is copied and optimized to achieve a smaller file size. After that, the optimized image is converted to the WebP format and moved to a special directory accessible by the Nginx webserver.

**5. LQIP Generation:**
In addition, a low-resolution version of the image is created, converted to Base64, and stored in a file. This is used to generate the LQIPs for the blog post, which are displayed during the page load before the actual image is loaded.

**6. Cleanup:**
After all steps are successfully completed, the script deletes the temporary and optimized images.

**7. Synchronization:**
Finally, the script uses `syncthing`, to sync the generated Base64 files and blog post files to a remote server.

All in all, this script serves to optimize and automate the process of creating blog posts. It reduces the effort associated with manual image optimization and LQIP creation and simplifies the creation of blog posts in Jekyll.

Here is the full script. Remember that you will need to adjust the variables and paths to suit your own environment:

```bash
#!/bin/bash
dir=/path/to/import
base64dir=$dir/path/to/base64
imagedir=/path/to/public/images
postsdir=/path/to/posts
remote_dir=user@jekyll-server:~/path/to/newposts
echo "Script started." > /var/log/webp-converter/info.log
mkdir -p $base64dir $imagedir $postsdir || { echo "Failed to create directories"; exit 1; }

image_count=0
echo "Image count is now $image_count" >> /var/log/webp-converter/info.log

inotifywait -m $dir -e create -e moved_to --format '%w%f' -r |
    while read file; do
	echo "New File detected: $file" >> /var/log/webp-converter/info.log
        relative_path=${file#$dir/}
        if [[ $file =~ .jpg$ ]] && [[ $file != *_optimized.jpg ]] && [[ $file != .* ]]; then
            echo "Processing $file..." >> /var/log/webp-converter/info.log
		
            postname=$(basename $(dirname $file))
            filename=$(basename $file .jpg)

            postdir=$imagedir/$postname
            mkdir -p $postdir || { echo "Failed to create directory $postdir"; continue; }

            mdfile=$postsdir/$(date +'%Y-%m-%d')-${postname}.md

            optimized=$dir/${relative_path%.*}_optimized.jpg
            rsync -avP $file $optimized || { echo "Failed to copy $file"; continue; }
            jpegoptim -s $optimized || { echo "Failed to optimize $file"; continue; }

            webp=$postdir/${filename}.webp
            cwebp -q 80 $optimized -o $webp || { echo "Failed to convert $file to WebP"; continue; }

            base64file=$base64dir/${filename}_optimized.base64
            convert $optimized -resize 20 - | base64 | tr -d '\n' > $base64file || { echo "Failed to convert $file to Base64"; continue; }

            image_path="https://images.example.com/blog/$postname/${filename}.webp"
            base64_string=$(cat $base64file)

            image_count=$(grep -c "image:" $mdfile)
		echo "Image count is now $image_count" >> /var/log/webp-converter/info.log
            if [[ $image_count -eq 0 ]]; then
		echo "Writing header to $mdfile" >> /var/log/webp-converter/info.log
                echo "---" > $mdfile || { echo "Failed to create $mdfile"; continue; }
                echo "layout: post" >> $mdfile
		echo "title: \"Title Here\"" >> $mdfile
                echo "date: $(date +'%Y-%m-%d %H:%M:%S %z')" >> $mdfile
                echo "categories: category1 category2" >> $mdfile
                echo "tags: tag1 tag2" >> $mdfile
                echo "author: "Christian Strube"" >> $mdfile
                echo "image:" >> $mdfile || { echo "Failed to write to $mdfile"; continue; }
                echo "  path: $image_path" >> $mdfile
                echo "  lqip: data:image/jpeg;base64,$base64_string" >> $mdfile
		        echo "---" >> $mdfile	
		((image_count++))
                echo "Image count is now $image_count" >> /var/log/webp-converter/info.log
	    else
		echo "Writing image link to $mdfile" >> /var/log/webp-converter/info.log
                echo "![$filename!]($image_path){: w=\"338\" h=\"600\" lqip=\"data:image/jpeg;base64,$base64_string\" }" >> $mdfile
            fi
		echo "Finished processing $file" >> /var/log/webp-converter/info.log
            [ -e "$optimized" ] && rm $optimized

	     echo "$file processed successfully"
        fi
    done
echo "Script Finished." >> /var/log/webp-converter/info.log
```

With this script, you can upload the images to the `uploads/import` directory and the script monitors this directory to automatically create a new blog post, optimize the image, and generate the LQIP.

>Please note that you will need the correct login credentials for your remote server and the `jpegoptim`, `cwebp` and `convert` (part of ImageMagick) commands must be installed on your server for the script to work.
{: .prompt-info }