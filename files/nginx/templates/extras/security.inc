# WordPress Hardening - tmp
# http://codex.wordpress.org/Hardening_WordPress 
if ($request_uri ~ ^/wp-admin/includes/) { return 403; }
if ($request_uri ~ ^/wp-includes/js/tinymce/langs/.+\.php$) { return 403; }
if ($request_uri ~ ^/wp-includes/theme-compat/) { return 403; }
if ($request_uri ~ ^/wp-config\.php$) { return 403; }

# W3TC Hardening
if ($request_uri ~ ^/wp-content/((advanced|object)-)?cache(\.php)?(/)?$) { return 403; }
if ($request_uri ~ ^/wp-content/db\.php$) { return 403; }
if ($request_uri ~ ^/wp-content/w3tc/(db|object)cache) { return 403; }

if ($request_uri ~ ^/readme.html) {return 403;}
if ($request_uri ~ "\.sql$") {return 403;}
if ($request_uri ~ "wp-content/uploads/member-access") {return 403;}


# Block out any script trying to base64_encode crap to send via URL
if ( $query_string ~ "base64_encode.*\(.*\)" ) { return 403 ; }

# Block out any script that includes a <script> tag in URL
if ( $query_string ~ "(\<|%3C).*script.*(\>|%3E)" ) { return 403 ; }

# Block out any script trying to set a PHP GLOBALS variable via URL
if ( $query_string ~ "GLOBALS(=|\[|\%[0-9A-Z]{0,2})" ) { return 403 ; }

# Block out any script trying to modify a _REQUEST variable via URL
if ( $query_string ~ "_REQUEST(=|\[|\%[0-9A-Z]{0,2})" ) { return 403 ; }

# Block anyone trying to peak at .sh files
 
if ($request_uri ~ "\.sh$") {return 403;}
if ($request_uri ~ "searchreplacedb2?\.php$") {return 403;}
 
# to fix https://www.ruby-forum.com/topic/4418673
if ($request_uri ~ " ") { return 444; }

# Prevents the download of wp-config.php via revslider
# http://blog.sucuri.net/2014/09/slider-revolution-plugin-critical-vulnerability-being-exploited.html
if ($query_string ~ "action=revslider_show_image&img=\.\./wp-config\.php") { return 444; }
