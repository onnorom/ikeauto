class ikeautomata ( 
  String $chkoutdir = '/tmp',
  String $servicetype = lookup('ikeautomata::service::type', String, 'first', 'service'),
) {

  if ($facts['checkoutdir']) {
    $workingdir = $facts['checkoutdir']
  } else {
    $workingdir = $chkoutdir
  } 

  $updater = $facts['os']['family'] ? {
    'windows' => { 'type' => 'windows', 'script' => "${workingdir}\\update.bat" },
    default   => { 'type' => 'default', 'script' => "${workingdir}/update.sh" }
  } 

  notify {"Automating with $name":}
  notice ("Using: $workingdir")
  
  ensure_resource('class', "ikeautomata::service::${updater['type']}", { 'script' => "${updater['script']}", 'type' => $servicetype })
}
