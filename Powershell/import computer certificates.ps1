$mypwd = Get-Credential -UserName 'Enter password below' -Message 'Enter password below'

Import-PfxCertificate -FilePath C:\allTrustedRoot2.pfx -CertStoreLocation Cert:\LocalMachine\My -Password $mypwd.Password
