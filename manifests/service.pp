class ikeautomata::service (
    String $script,
    String $sleep_interval = lookup('runinterval', String, 'first', '600'),
    Boolean $ensure = true,
) {

    ensure_resource ('file', '/var/automata', { ensure => 'directory', mode   => '0755' })
    ensure_resource ('file', '/var/automata/pid', { ensure => 'directory', mode   => '0755' })
    ensure_resource ('file', '/var/automata/logs', { ensure => 'directory', mode   => '0755' })
    ensure_resource ('file', '/etc/automata', { ensure => 'directory', mode   => '0755' })
    ensure_resource ('file', '/etc/automata/bin', { ensure => 'directory', mode   => '0755' })

    $service = { 'start' => '/etc/automata/bin/worker.sh', 'stop' => '/bin/kill -s SIGUSR1 $MAINPID' }

    file { '/etc/automata/bin/worker.sh':
        ensure  => present,
        mode    => '0755',
        content => epp('ikeautomata/worker.epp', {
            update_script_path => $script,
            pidfile            => '/var/automata/pid/automata.pid',
            sleep_secs         => $sleep_interval,
        })
    }

    # Manage the services
    file { '/etc/systemd/system/ikeautomata.service':
        ensure  => present,
        content => epp('ikeautomata/service.epp', {
            startstr => $service['start'],
            stopstr  => $service['stop'],
        })
    }

    # Reload the changed file
    exec { '/bin/systemctl daemon-reload':
        refreshonly => true,
        notify      => Service['ikeautomata'],
        require     => File['/etc/systemd/system/ikeautomata.service'],
    }

    # Enable service in the node and startup if not explicitly turned off
    service { 'ikeautomata':
        ensure    => $ensure,
        enable    => true,
        subscribe => File['/etc/systemd/system/ikeautomata.service'],
        require   => File['/etc/systemd/system/ikeautomata.service'],
    }
}
