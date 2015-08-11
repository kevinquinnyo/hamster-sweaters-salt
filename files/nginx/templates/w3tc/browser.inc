# BEGIN W3TC Browser Cache - tmp change
gzip on;
gzip_types text/css text/x-component application/x-javascript application/javascript text/javascript text/x-js text/richtext image/svg+xml text/plain text/xsd text/xsl text/xml image/x-icon;
location ~ \.(css|htc|js|js2|js3|js4)$ {
    expires 31536000s;
    add_header Pragma "public";
    add_header Cache-Control "max-age=31536000, public, must-revalidate, proxy-revalidate";
}
location ~ \.(html|htm|rtf|rtx|svg|svgz|txt|xsd|xsl|xml)$ {
    expires 3600s;
    add_header Pragma "public";
    add_header Cache-Control "max-age=3600, public, must-revalidate, proxy-revalidate";
    try_files $uri $uri/ $uri.html /index.php?$args;
}
location ~ \.(asf|asx|wax|wmv|wmx|avi|bmp|class|divx|doc|docx|eot|exe|gif|gz|gzip|ico|jpg|jpeg|jpe|json|mdb|mid|midi|mov|qt|mp3|m4a|mp4|m4v|mpeg|mpg|mpe|mpp|otf|odb|odc|odf|odg|odp|ods|odt|ogg|pdf|png|pot|pps|ppt|pptx|ra|ram|svg|svgz|swf|tar|tif|tiff|ttf|ttc|wav|wma|wri|xla|xls|xlsx|xlt|xlw|zip)$ {
    expires 31536000s;
    add_header Pragma "public";
    add_header Cache-Control "max-age=31536000, public, must-revalidate, proxy-revalidate";
}
# END W3TC Browser Cache
