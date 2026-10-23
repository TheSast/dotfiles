function wh
    set usage_msg "usage: "(status function)" <os|home> switch -i <sshIdentity> <remote_ip> <userNAME@hostNAME> <flake> [--build-on-local|--build-on-remote]"
    if test (count $argv) -lt 7 || test (count $argv) -gt 8
        echo $usage_msg
        return 1
    end
    set deployment_type $argv[1]
    # switch
    # -i
    set ident $argv[4]
    set remote_ip $argv[5]
    set targetname $argv[6]
    set flake $argv[7]
    set build_location $argv[8]
    if test $argv[3] != -i || test $argv[2] != switch || not string match -rq '^[a-z]+@[a-z]+$' -- "$targetname"
        echo $usage_msg
        return 1
    end
    if test (count $argv) -eq 8
        if test $build_location != --build-on-remote && test $build_location != --build-on-local
            echo $usage_msg
            return 1
        end
    end
    if test $deployment_type != os && test $deployment_type != home
        echo $usage_msg
        return 1
    end

    echo -- '----------- EVALUATING CONFIG -----------'
    # echo -- '---------- BUILDING DERIVATION ----------' # better?
    if test $deployment_type = os
        set attr "windowsConfigurations."(string replace -r '.*@' '' $targetname)".config.system.build.toplevel"
    else if test $deployment_type = home
        set attr "windowsHomeConfigurations."(string replace -r '@.*' '' $targetname)"@"(string replace -r '.*@' '' $targetname)".config.system.build.toplevel"
    else
        echo "unreachable!()"
        return 1
    end
    set derivation (nix eval --raw "$flake#$attr.drvPath")
    or return 1

    if string match -q -- --build-on-local $build_location
        echo -- '------ BUILDING CLOSURE (on local) ------'
        ssh -i $ident $remote_ip "wsl sleep 5"
        or return 1
        set out (nix build "$derivation^*" --no-link --print-out-paths)
        or return 1
        set out $out[1] # there is only one path, so this may be unnecessary

        echo -- '---------- TRANSFERING CLOSURE ----------'
        ssh -i $ident $remote_ip "wsl sleep 5"
        or return 1
        NIX_SSHOPTS="-p 2222 -i $ident" nix copy --to ssh-ng://$remote_ip $out
        # ^ can't pull cause that means remote must have ssh credentials for local, which is a bad idea atm
        or return 1
    else
        echo -- '--------- TRANSFERING DERIVATION --------'
        ssh -i $ident $remote_ip "wsl sleep 5"
        or return 1
        NIX_SSHOPTS="-p 2222 -i $ident" nix copy --to ssh-ng://$remote_ip $derivation
        or return 1

        echo -- '------ BUILDING CLOSURE (on remote) -----'
        ssh -i $ident $remote_ip "wsl sleep 5"
        or return 1
        set out (ssh -p 2222 -i $ident $remote_ip nix build "$derivation^*" --no-link --print-out-paths)
        or return 1
        set out $out[1] # there is only one path, so this may be unnecessary
    end

    echo -- '--------------- ACTIVATING --------------'
    ssh -i $ident $remote_ip "wsl sudo --non-interactinve $out/bin/activate"
    or return 1
end
