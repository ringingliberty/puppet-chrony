require 'puppet'
Facter.add('chrony_version') do
  confine :kernel => 'Linux'
  setcode do
    if Facter::Util::Resolution.which('chronyc')
      chrony_version = Facter::Util::Resolution.exec('chronyc -v 2>&1')
      # eg chronyc (chrony) version 3.0 (+READLINE +IPV6 -DEBUG)
      %r{^chronyc \(chrony\) version ([\w\.]+)}.match(chrony_version)[1]
    elsif Facter::Util::Resolution.which('rpm') and Facter.value(:osfamily) == 'redhat'
      Facter::Util::Resolution.exec('rpm -q --queryformat \'%{VERSION}\' chrony')
    elsif Facter::Util::Resolution.which('dpkg-query') and Facter.value(:osfamily) == 'debian'
      Facter::Util::Resolution.exec('dpkg-query -W -f=\'${Version}\n\' chrony')
    else
      nil
    end
  end
end

