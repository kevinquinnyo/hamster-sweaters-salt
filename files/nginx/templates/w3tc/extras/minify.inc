# BEGIN W3TC CDN
location ~ \.(ttf|otf|eot|woff)$ {
   add_header Access-Control-Allow-Origin "*";
}
# END W3TC CDNroot@advus49.wsynth.net:/etc/nginx/conf.d/w3tc# cat w3tc_minify.inc
# BEGIN W3TC Minify cache
location ~ /wp-content/cache/minify.*\.js$ {
    types {}
    default_type application/x-javascript;
    expires modified 31536000s;
    add_header X-Powered-By "W3 Total Cache";
    add_header Vary "Accept-Encoding";
    add_header Pragma "public";
    add_header Cache-Control "max-age=31536000, public, must-revalidate, proxy-revalidate";
}
location ~ /wp-content/cache/minify.*\.css$ {
    types {}
    default_type text/css;
    expires modified 31536000s;
    add_header X-Powered-By "W3 Total Cache";
    add_header Vary "Accept-Encoding";
    add_header Pragma "public";
    add_header Cache-Control "max-age=31536000, public, must-revalidate, proxy-revalidate";
}
location ~ /wp-content/cache/minify.*js\.gzip$ {
    gzip off;
    types {}
    default_type application/x-javascript;
    expires modified 31536000s;
    add_header X-Powered-By "W3 Total Cache";
    add_header Vary "Accept-Encoding";
    add_header Pragma "public";
    add_header Cache-Control "max-age=31536000, public, must-revalidate, proxy-revalidate";
    add_header Content-Encoding gzip;
}
location ~ /wp-content/cache/minify.*css\.gzip$ {
    gzip off;
    types {}
    default_type text/css;
    expires modified 31536000s;
    add_header X-Powered-By "W3 Total Cache";
    add_header Vary "Accept-Encoding";
    add_header Pragma "public";
    add_header Cache-Control "max-age=31536000, public, must-revalidate, proxy-revalidate";
    add_header Content-Encoding gzip;
}
# END W3TC Minify cache

# BEGIN W3TC Minify core
rewrite ^/wp-content/cache/minify.*/w3tc_rewrite_test$ /wp-content/plugins/w3-total-cache/pub/minify.php?w3tc_rewrite_test=1 last;
set $w3tc_enc "";
if ($http_accept_encoding ~ gzip) {
    set $w3tc_enc .gzip;
}
if (-f $request_filename$w3tc_enc) {
    rewrite (.*) $1$w3tc_enc break;
}
rewrite ^/wp-content/cache/minify/(.+/[X]+\.css)$ /wp-content/plugins/w3-total-cache/pub/minify.php?test_file=$1 last;
rewrite ^/wp-content/cache/minify/(.+\.(css|js))$ /wp-content/plugins/w3-total-cache/pub/minify.php?file=$1 last;
# END W3TC Minify
