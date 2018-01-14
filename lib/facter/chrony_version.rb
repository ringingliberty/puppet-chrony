Facter.add('chrony_version') do
    confine :kernel => :linux
    setcode do
        version = Facter::Core::Execution.exec("/bin/rpm -q --queryformat '%{VERSION}-%{RELEASE}' chrony")
        if version != nil
            version.chomp!
        else
            nil
        end
    end
end
