class {'varnish':
  add_repo => false,
}

class { 'varnish::vcl':
  purgeips => ['"127.0.0.1"', '"172.17.0.0"/16']
}

# configure probes
varnish::probe { 'health_check1': 
  url       => '/', 
  window    => '5',
  threshold => '2',
  interval  => '10s',
}

# configure backends
varnish::backend { 'hatut8532': host => '127.0.0.1', port => '8532', probe => 'health_check1' }
varnish::backend { 'hatut8533': host => '127.0.0.1', port => '8533', probe => 'health_check1' }
varnish::backend { 'ytk8072': host => '127.0.0.1', port => '8072', probe => 'health_check1' }


# configure directors
varnish::director { 'hatut': backends => [ 'hatut8532', 'hatut8533' ] }
varnish::director { 'ytk': backends => [ 'ytk8072' ] }

# configure selectors
varnish::selector { 'hatut': condition => 'req.url ~ "^/VirtualHostBase/https/www.jyu.fi:443/hatut"' }
varnish::selector { 'ytk': condition => 'req.url ~ "^/VirtualHostBase/https/www.jyu.fi:443/ytk"' }

