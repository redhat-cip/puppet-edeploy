class edeploy::webserver (
  $docroot,
  $access_log = true,
  $access_file = '/var/log/httpd/edeploy_access_log.log',
  $error_file = true,
  $error_file = '/var/log/httpd/edploy_error_log.log',
  $port = 80,
  $address = undef
) {


  class {'apache' :
    default_vhost => false,
  }
  apache::vhost {'edeploy.example.com' :
    docroot    => $docroot,
    port       => $port,
    options    => ['Indexes','FollowSymLinks','MultiViews', 'ExecCGI'],
    access_log => $access_log,
    error_log  => $error_log,
    custom_fragment => "AddHandler cgi-script .cgi .py",
  }

}
