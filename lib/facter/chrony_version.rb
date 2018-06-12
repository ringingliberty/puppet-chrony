Facter.add('chrony_version') do
    confine :kernel => 'Linux'
    setcode do
        version = Facter::Core::Execution.exec("/bin/rpm -q --queryformat '%{VERSION}' chrony")
        if version != nil
            version
        else
            nil
        end
    end
end
