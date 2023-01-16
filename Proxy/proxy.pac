//Javascript Source code

function FindProxyForURL(url, host)
 {

// If an Intranet site go direct
if (isPlainHostName(host) ||
shExpMatch(host, "*.local") ||
shExpMatch(host, "*.localhost* ") ||
dnsDomainIs(url, ".mimecast.com*") ||
shExpMatch(url, "<FULL DOMAIN NAME>") ||
isInNet(dnsResolve(host), "192.168.0.0",  "255.255.0.0"))
{return "DIRECT";}

// Don't proxy Creative Cloud.
if (shExpMatch(url, "na1mbls.licenses.adobe.com") ||
shExpMatch(url, "127.0.0.1:*") ||
shExpMatch(url, "ims-na1.adobelogin.com:*") ||
shExpMatch(url, "adobeid-na1.services.adobe.com*") ||
shExpMatch(url, "na1r.services.adobe.com*") ||
shExpMatch(url, "activate.adobe.com*") ||
shExpMatch(url, "adobe.activate.com*") ||
shExpMatch(url, "ccmdls.adobe.com:*") ||
shExpMatch(url, "ccmdl.adobe.com:*") ||
shExpMatch(url, "na1r.services.adobe.com*") ||
shExpMatch(url, "prod-rel-ffc-ccm.oobesaas.adobe.com:*") ||
shExpMatch(url, "lm.licenses.adobe.com:*") ||
shExpMatch(url, "www-du1.adobe.com*") ||
shExpMatch(url, "swupmf.adobe.com:*") ||
shExpMatch(url, "swupdl.adobe.com:*") ||
shExpMatch(url, "na1r.services.adobe.com*") ||
dnsDomainIs(url, ".adobe.com*") ||
dnsDomainIs(url, ".adobe.io*") ||
dnsDomainIs(url, ".adobelogin.") ||
dnsDomainIs(url, ".acl.") ||
dnsDomainIs(url, ".adobedl.") ||
dnsDomainIs(url, ".dstdomain.") ||
dnsDomainIs(url, ".adobeoobe.com*") ||
dnsDomainIs(url, ".data-web.fr*") ||
shExpMatch(url, "dscms.akamai.net*") ||
shExpMatch(url, "elb.amazonaws.com") ||
shExpMatch(url, "ccmdl.adobe.com*") ||
shExpMatch(url, "ccmdls.adobe.com*") ||
shExpMatch(url, "ims-prod06.adobelogin.com*") ||
shExpMatch(url, "interaction.adobe.com*") ||
shExpMatch(url, "prod-rel-ffc.oobesaas.adobe.com*") ||
shExpMatch(url, "prod.acp.adobeoobe.com*") ||
shExpMatch(url, "scss.adobesc.com*") ||
shExpMatch(url, "scss-prod-ew1.adobesc.com*") ||
shExpMatch(url, "scss-prod-ew1-notif-9.adobesc.com*") ||
shExpMatch(url, "www-du1.adobe.com") ||
shExpMatch(url, "scss-prod-an1-notif-8.adobesc.com") ||
shExpMatch(url, "scss-prod-an1-notif-7.adobesc.com") ||
shExpMatch(url, "scss-prod-ue1-notif-5.adobesc.com") ||
shExpMatch(url, "scss-prod-ue1-notif-11.adobesc.com") ||
shExpMatch(url, "scss-prod-an1-notif-2.adobesc.com") ||
shExpMatch(url, "scss-prod-an1-notif-4.adobesc.com") ||
shExpMatch(url, "scss-prod-an1-notif-3.adobesc.com") ||
shExpMatch(url, "scss-prod-an1-notif-1.adobesc.com") ||
shExpMatch(url, "scss-prod-an1-notif-5.adobesc.com") ||
shExpMatch(url, "scss-prod-ue1-notif-10.adobesc.com") ||
shExpMatch(url, "scss-prod-ew1.adobesc.com:443") ||
shExpMatch(url, "*adobe.com*") ||
shExpMatch(url, "*adobelogin.com*") ||
shExpMatch(url, "*typekit.com*") ||
shExpMatch(url, "*adobesc.com*") ||
dnsDomainIs(url, "*.typekit.com*") ||
shExpMatch(url, "*.amazonses.com*") ||
shExpMatch(url, "ims-na1.adobelogin.com") ||
shExpMatch(url, "adobelogin.prod.ims.adobejanus.com") ||
shExpMatch(url, "api.typekit.com") ||
shExpMatch(url, "indd.adobe.com") ||
shExpMatch(url, "uds.licenses.adobe.com") ||
shExpMatch(url, "genuine.adobe.com") ||
shExpMatch(url, "psdk.adobe.io") ||
shExpMatch(url, "accounts.adobe.com") ||
shExpMatch(url, "cc-api-storage.adobe.io") ||
shExpMatch(url, "ars.adobeoobe.com") ||
shExpMatch(url, "sscs-prod-ew1-notif-16.adobesc.com") ||
shExpMatch(url, "www.adobeexchange.com") ||
shExpMatch(url, "www.adobe.com.edgekey.net") ||
dnsDomainIs(url, "*.edgekey.net*") ||
shExpMatch(url, "e4578.b.akamaiedge.net") ||
shExpMatch(url, "a3.behance.net") ||
shExpMatch(url, "oscp.digicert.com") ||
shExpMatch(url, "cc-collab.adobe.io") ||
shExpMatch(url, "indd.adobe.com") ||
shExpMatch(url, "na1e-acc.services.adobe.com") ||
shExpMatch(url, "jil-na1.services.adobe.com") ||
shExpMatch(url, "wwwimages2.adobe.com") ||
shExpMatch(url, "bam.nr-data.net") ||
shExpMatch(url, "p.typekit.net") ||
dnsDomainIs(url, "*.typekit.net") ||
shExpMatch(url, "fonts.typekit.net") ||
shExpMatch(url, "use.typekit.net") ||
shExpMatch(url, "*.behance.net") ||
shExpMatch(url, "*.adobe.io") ||
shExpMatch(url, "*.services.adobe.com") ||
shExpMatch(url, "*.nr-data.net") ||
shExpMatch(url, "static.adobelogin.com") ||
shExpMatch(url, "*.adobelogin.com") ||
shExpMatch(url, "js-agent.newrelic.com") ||
shExpMatch(url, "*.newrelic.com") ||
shExpMatch(url, "*.typekit.net") ||
shExpMatch(url, "invites.adobe.com") ||
shExpMatch(url, "use.typekit.net") ||
dnsDomainIs(url, "*.behance.net") ||
dnsDomainIs(url, "*.adobe.io") ||
dnsDomainIs(url, "*.services.adobe.com") ||
dnsDomainIs(url, "*.nr-data.net") ||
dnsDomainIs(url, "*.adobelogin.com") ||
dnsDomainIs(url, "*.newrelic.com") ||
dnsDomainIs(url, "amazonses.com") ||
dnsDomainIs(url, ".adobesc.com"))
{return "DIRECT";}

// Don't proxy ftps
if ((url.substring(0, 4) === "ftp:") ||
shExpMatch(url, "secure.gleedsspace.com") ||
dnsDomainIs(url, ".4projects.com") ||
shExpMatch(url, "lalitlondon.myconject.com") ||
dnsDomainIs(url, ".wetransfer.*") ||
dnsDomainIs(url, ".myconject.com"))
{return "DIRECT";}

// Microsoft Bypass
if (shExpMatch(url, "*nexus.officeapps.live.com*") ||
shExpMatch(url, "office15client.microsoft.com") ||
shExpMatch(url, "webpooldb30e06.infra.lync.com") ||
shExpMatch(url, "odc.officeapps.live.com") ||
shExpMatch(url, "omextemplates.content.office.net") ||
shExpMatch(url, "office.microsoft.com") ||
shExpMatch(url, "officeimg.vo.msecnd.net") ||
shExpMatch(url, "sa.symcb.com") ||
shExpMatch(url, "messaging.office.com") ||
shExpMatch(url, "prod.msocdn.com") ||
shExpMatch(url, "roaming.officeapps.live.com") ||
shExpMatch(url, "ols.officeapps.live.com") ||
shExpMatch(url, "mscrl.microsoft.com") ||
shExpMatch(url, "activation.sls.microsoft.com") ||
shExpMatch(url, "test-my.sharepoint.com") ||
shExpMatch(url, "autodiscover-s.outlook.com") ||
shExpMatch(url, "outlook.office365.com") ||
shExpMatch(url, "pod51049.outlook.com") ||
shExpMatch(url, "glbdns.microsoft.com") ||
shExpMatch(url, "store.office.com") ||
shExpMatch(url, "*webpooldb30e06.infra.lync.com*") ||
shExpMatch(url, "*.infra.lync.com*") ||
shExpMatch(url, "*office15client.microsoft.com*") ||
shExpMatch(url, "*quicktips.skypeforbusiness.com*") ||
shExpMatch(url, "pipe.skype.com") ||
shExpMatch(url, "client.akamai.com") ||
shExpMatch(url, "cn1.redswoosh.akadns.net") ||
shExpMatch(url, "log.client.akadns.net") ||
dnsDomainIs(url, "webpooldb30e06.infra.lync.com") ||
dnsDomainIs(url, ".microsoftonline.com*") ||
dnsDomainIs(url, ".microsoftonline-p.com*") ||
dnsDomainIs(url, "nexus.officeapps.live.com*") ||
dnsDomainIs(url, ".onmicrosoft.com*") ||
dnsDomainIs(url, ".sharepoint.com*") ||
dnsDomainIs(url, ".outlook.com*") ||
dnsDomainIs(url, ".verisign.com*") ||
dnsDomainIs(url, ".verisign.net*") ||
dnsDomainIs(url, ".public-trust.com") ||
dnsDomainIs(url, "*.lync.*") ||
dnsDomainIs(url, ".sharepoint.com*") ||
dnsDomainIs(url, ".microsoftonlinesupport.net*") ||
dnsDomainIs(url, ".office365.com*") ||
shExpMatch(url, "iecvlist.microsoft.com") ||
shExpMatch(url, "osub.microsoft.com") ||
dnsDomainIs(url, ".windows.net") ||
dnsDomainIs(url, ".live.com") ||
dnsDomainIs(url, ".msedge.net") ||
dnsDomainIs(url, ".cloudapp.net") ||
dnsDomainIs(url, ".office.com") ||
shExpMatch(url, "templateservice.office.com") ||
shExpMatch(url, "*.office.com") ||
shExpMatch(url, "roaming.officeapps.live.com") ||
shExpMatch(url, "euc-onenote.officeapps.live.com") ||
shExpMatch(url, "docs.live.net") ||
shExpMatch(url, "euc-onenote.officeapps.live.com") ||
shExpMatch(url, "p.pfx.ms") ||
dnsDomainIs(url, ".microsoft.com*"))
{return "DIRECT";}

// Autodesk
if (shExpMatch(url, "*.autodesk.com") ||
dnsDomainIs(url, ".autodesk.com") ||
shExpMatch(url, "*.google-analytics.com") ||
dnsDomainIs(url, ".google-analytics.com") ||
shExpMatch(url, "*.cloudfront.net") ||
dnsDomainIs(url, ".cloudfront.net") ||
shExpMatch(url, "*.virtualearth.net") ||
dnsDomainIs(url, ".virtualearth.net") ||
shExpMatch(url, "*.autocadws.com") ||
dnsDomainIs(url, ".autocadws.com") ||
shExpMatch(url, "*.newrelic.com") ||
dnsDomainIs(url, ".newrelic.com") ||
shExpMatch(url, "*.akamaiedge.net") ||
dnsDomainIs(url, ".akamaiedge.net") ||
shExpMatch(url, "*.amazonaws.com") ||
dnsDomainIs(url, ".amazonaws.com") ||
shExpMatch(url, "*.getsatisfaction.com") ||
dnsDomainIs(url, ".getsatisfaction.com") ||
shExpMatch(url, "accounts.autodesk.com") ||
dnsDomainIs(url, "accounts.autodesk.com") ||
shExpMatch(url, "*.autodesk360.com") ||
dnsDomainIs(url, ".autodesk360.com") ||
shExpMatch(url, "*.skyscraper.autodesk.com") ||
shExpMatch(url, "*.hotjar.com") ||
dnsDomainIs(url, ".hotjar.com") ||
shExpMatch(url, "Cdn.optimizely.com") ||
shExpMatch(url, "*.optimizely.com") ||
shExpMatch(url, "Si.dell.com") ||
shExpMatch(url, "raas2.autodesk.com") ||
shExpMatch(url, "www.googletagmanager.com") ||
shExpMatch(url, "www.google-analytics.com") ||
dnsDomainIs(url, "ssl-google-analytics.com") ||
shExpMatch(url, "Api.autodesk.com") ||
shExpMatch(url, "js-agent.newrelic.com") ||
shExpMatch(url, "fonts.googleadapis.l.google.com") ||
shExpMatch(url, "fonts.gstatic.com") ||
shExpMatch(url, "gstaticadssl.l.google.com") ||
shExpMatch(url, "news.officeaps.live.com") ||
shExpMatch(url, "prod-w.nexus.live.com.akadns.net") ||
shExpMatch(url, "wildcard.autodesk.com.edgekey.net") ||
shExpMatch(url, "cdn.jsdelivr.net") ||
dnsDomainIs(url, ".l.google.com") ||
dnsDomainIs(url, ".edgekey.net") ||
shExpMatch(url, "www-wildcard.autodesk.com.edgekey.net") ||
shExpMatch(url, "*.nr-data.net ") ||
shExpMatch(url, "*.velasystems.com") ||
shExpMatch(url, "*.msecnd.net") ||
shExpMatch(url, "*.akamaitechnologies.com") ||
shExpMatch(url, "*.skyscraper.autodesk.com") ||
shExpMatch(url, "*.ssl.google-analytics.com") ||
shExpMatch(url, "*.js-agent.newrelic.com") ||
dnsDomainIs(url, ".vabi.nl") ||
shExpMatch(url, "area51.vabi.nl") ||
shExpMatch(url, "*.vabi.nl") ||
shExpMatch(url, "*.edgekey.net") ||
shExpMatch(url, "raas2.autodesk.com") ||
shExpMatch(url, "raas2.autodesk.com/Render") ||
shExpMatch(url, "*.imiclk.com") ||
dnsDomainIs(url, ".imiclk.com") ||
shExpMatch(url, "a248.e.akamai.net") ||
dnsDomainIs(url, ".akamai.net") ||
shExpMatch(url, "*.akamai.net") ||
shExpMatch(url, "akamai.mathtag.com") ||
dnsDomainIs(url, ".mathtag.com") ||
shExpMatch(url, "tos-a.akamaihd.net") ||
dnsDomainIs(url, ".akamaihd.net") ||
shExpMatch(url, "api.admin.xinaps.com") ||
shExpMatch(url, "license.xrev.com*"))
{return "DIRECT";}

// Other Bypass
if (shExpMatch(url, "*poolname-webint.co.uk") ||
shExpMatch(url, "us.unionsquaresoftware.com*") ||
shExpMatch(url, "Monitor.foundation-it.com*") ||
shExpMatch(url, "area51.vabi.nl*") ||
dnsDomainIs(url, ".ntradmin.com*") ||
dnsDomainIs(url, ".ntrglobal.com*") ||
dnsDomainIs(url, ".ntrsupport.com*") ||
dnsDomainIs(url, ".bgportal.co.uk*") ||
dnsDomainIs(url, "*.pinterest.*") ||
shExpMatch(url, "*.pinterest.*") ||
dnsDomainIs(url, "*.pinimg.*") ||
shExpMatch(url, "*.pinimg.com") ||
dnsDomainIs(url, ".cadbox.com*") ||
dnsDomainIs(url, ".cadfaster.com*") ||
dnsDomainIs(url, ".huddle.*") ||
dnsDomainIs(url, ".zendesk.*") ||
dnsDomainIs(url, ".rackcdn.*") ||
dnsDomainIs(url, ".qubitproducts.*") ||
dnsDomainIs(url, ".mixpanel.*") ||
dnsDomainIs(url, ".europeanhoteldesignawards.com") ||
dnsDomainIs(url, ".sleepermagazine.com") ||
dnsDomainIs(url, ".sharepoint.com*") ||
dnsDomainIs(url, ".bigfilebox.*") ||
dnsDomainIs(url, ".orlight.*") ||
shExpMatch(url, "*.orlight.*") ||
shExpMatch(url, "*.building.*") ||
shExpMatch(url, "*.architectsjournal.*") ||
shExpMatch(url, "*.bdonline.*") ||
shExpMatch(url, "*.propertyweek.*") ||
shExpMatch(url, "www.propertyweek.com") ||
shExpMatch(url, "www.preconstruct.com") ||
shExpMatch(url, "hplanbuild.southwark.gov.uk") ||
dnsDomainIs(url, "*.akamaitechnologies.com*") ||
dnsDomainIs(url, "*humanrace.co.uk*") ||
dnsDomainIs(url, "*.luxigon.*") ||
dnsDomainIs(url, "*.big.*") ||
shExpMatch(url, "www.luxigon.com") ||
shExpMatch(url, "www.big.dk") ||
dnsDomainIs(url, "*.lefroybrooks.*") ||
shExpMatch(url, "uk.lefroybrooks.com") ||
shExpMatch(url, "home.thorsen.pm") ||
dnsDomainIs(url, "*.msn.com") ||
dnsDomainIs(url, "*.gotomeeting.com") ||
dnsDomainIs(url, "*.webex.com") ||
dnsDomainIs(url, "*.mozilla.org") ||
dnsDomainIs(url, "*.blackspider.com") ||
dnsDomainIs(url, "*.mailcontrol.com") ||
dnsDomainIs(url, "*.citrixonline.com") ||
dnsDomainIs(url, "*.expertcity.com") ||
dnsDomainIs(url, "*.netdna-cdn.com") ||
dnsDomainIs(url, "*.squarespace.com") ||
shExpMatch(url, "create.thenbs.com*") ||
shExpMatch(url, "services.thenbs.com*") ||
shExpMatch(url, "services.ribae.com*") ||
dnsDomainIs(url, ".ribae.com") ||
dnsDomainIs(url, ".thenbs.com") ||
shExpMatch(url, "services.ribae.com/nbsonlineupdates/VersionInfo.asmx") ||
shExpMatch(url, "services.ribae.com/nbsproductdata2/NextGenNBSPlusService.asmx") ||
shExpMatch(url, "create.thenbs.com/ServiceMessageService14/NBSCreateServiceMessages.svc") ||
dnsDomainIs(url, ".sharefile.com") ||
shExpMatch(url, "*.sharefile.com") ||
dnsDomainIs(url, ".hubbub.net") ||
shExpMatch(url, "www.tungsten-network.com") ||
shExpMatch(url, "www.progressprofiles.com") ||
shExpMatch(url, "*.mimecast.*") ||
shExpMatch(url, "pinnacleweb.eaglepoint.com") ||
shExpMatch(url, "pinnacle.blob.core.windows.net") ||
shExpMatch(url, "pinnacleonecloud.cloudapp.net") ||
dnsDomainIs(url, ".eaglepoint.com") ||
dnsDomainIs(url, ".windows.net") ||
dnsDomainIs(url, ".cloudapp.net") ||
shExpMatch(url, "*.eaglepoint.*") ||
shExpMatch(url, "*.windows.*") ||
shExpMatch(url, "*.cloudapp.*") ||
dnsDomainIs(url, ".propertytriathlon.com*"))
{return "DIRECT";}

//To test Deny
 if (dnsDomainIs(host, ".miniclip.com")) 
{return "PROXY http://0.0.0.0:18080";}
else
// DEFAULT RULE: All other traffic, use below proxies, in fail-over.
{return "PROXY <IP OF PROXY>:<PORT>";}
} // End of function
