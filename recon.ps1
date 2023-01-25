# Host Discovery
# Descobre todos os hosts da rede e salva em 2 arquivos, HostsTrue e HostsFalse
# HostsTrue deverá ser testado se tem aplicacao web e HostsFalse é recomendável fazer um novo scan utilizando um novo IP (A fim de evitar blocks do Firewall)
$net = '192.168'
(0..1) | foreach {
    $subnet = "$net.$_"

    (1..254) | foreach {
        $ip = "$subnet.$_"
        $props = @{
            'IP' = $ip;
            'Name' = (Resolve-DnsName $ip -errorAction SilentlyContinue | select -ExpandProperty NameHost);
            'Response' = (Test-Connection $ip -Quiet -Count 1)
        }

        $obj = New-Object -TypeName psobject -Property $props
        if ($obj.Response -eq "False"){
            $ip | Out-File -Append -FilePath hostsTrue.txt
        } else {
            $ip | Out-File -Append -FilePath hostsFalse.txt
        }
        $ip+" - "+$obj.Response| Write-Output
        
    }
}