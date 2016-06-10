## Introduction  

A system in Agave represents a server or collection of servers. A server can be physical, virtual, or a collection of servers exposed through a single hostname or ip address. Systems are identified and referenced in Agave by a unique ID unrelated to their ip address or hostname. Because of this, a single physical system may be registered multiple times. This allows different users to configure and use a system in whatever way they need to for their specific needs.

Systems come in two flavors: storage and execution. Storage systems are only used for storing and interacting with data. Execution systems are used for running apps (aka jobs or batch jobs) as well as storing and interacting with data.

The Systems service gives you the ability to add and discover storage and compute resources for use in the rest of the API. You may add as many or as few storage systems as you need to power your digital lab. When you register a system, it is private to you and you alone. Systems can also be published into the public space for all users to use. Depending on who is administering Agave for your organization, this may have already happened and you may already have one or more storage systems available to you by default.

In this tutorial we walk you through how to discovery, manage, share, and configure systems for your specific needs. This tutorial is best done in a hands-on manner, so if you do not have a compute or storage system of your own to use, you can grab a VM from our sandbox.

## Discovering systems  

The Systems service allows you to list and search for systems you have registered and systems that have been shared with you. To get a list of all your systems, make a GET request on the Systems collection.

```shell
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" https://$API_BASE_URL/systems/$API_VERSION/
```


```cli
systems-list -v
```


The response will be a JSON array of summary system objects. The full system description can get rather verbose, so a summary object is returned with the most critical fields in order to reduce response size when retrieving a user's systems.

```javascript
[
  {
    "id" : "data.iplantcollaborative.org",
    "name" : "iPlant Data Store",
    "type" : "STORAGE",
    "description" : "The iPlant Data Store is where your data are stored. The Data Store is cloud-based and is the central repository from which data is accessed by all of iPlant&#039;s technologies.",
    "status" : "UP",
    "public" : true,
    "default" : true,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/v2/data.iplantcollaborative.org"
      }
    }
  },
  {
    "id" : "docker.iplantcollaborative.org",
    "name" : "Demo Docker VM",
    "type" : "EXECUTION",
    "description" : "Atmosphere VM used for Docker demonstrations and tutorials.",
    "status" : "UP",
    "public" : true,
    "default" : false,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/v2/docker.iplantcollaborative.org"
      }
    }
  }
]
```

<aside class="notice">The above response my vary depending on who administers Agave for your organization. To customize this tutorial for your specific account, login.</aside>

You can further filter the results by type, scope, and default status.

```shell
```bash
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" https://$API_BASE_URL/systems/$API_VERSION/?type=storage
```
Only execution systems
```bash
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" https://$API_BASE_URL/systems/$API_VERSION/?type=execution
```
Only public systems
```bash
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" https://$API_BASE_URL/systems/$API_VERSION/?publicOnly=true
```
Only private systems
```bash
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" https://$API_BASE_URL/systems/$API_VERSION/?privateOnly=true
```
Only give the user's default systems
```bash
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" https://$API_BASE_URL/systems/$API_VERSION/?default=true
```


```cli
```bash
systems-list -v -S
```
Only execution systems
```bash
systems-list -v -E
```
Only public systems
```bash
systems-list -v -P
```
Only private systems
```bash
systems-list -v -Q
```
Only give the user's default systems
```bash
systems-list -v -D
```


To query for detailed information about a specific system, add the system id to the url and make another GET request.

```shell
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" https://$API_BASE_URL/systems/$API_VERSION/$SYSTEM_ID
```


```cli
systems-list -v $SYSTEM_ID
```


This time, the response will be a JSON object with a full system description. The following is the description of a storage system. In the next section we talk more about storage systems and how to register one of your own.

```javascript
{  
   "default":true,
   "description":"The iPlant Data Store is where your data are stored. The Data Store is cloud-based and is the central repository from which data is accessed by all of iPlant&#039;s technologies.",
   "id":"data.iplantcollaborative.org",
   "lastModified":"2013-11-12T07:08:30.000-06:00",
   "name":"iPlant Data Store",
   "public":true,
   "revision":4,
   "site":"iplantcollaborative.org",
   "status":"UP",
   "storage":{  
      "auth":{  
         "type":"PASSWORD"
      },
      "homeDir":"/",
      "host":"data.iplantcollaborative.org",
      "mirror":true,
      "port":1247,
      "protocol":"IRODS",
      "proxy":null,
      "publicAppsDir":null,
      "resource":"bitol",
      "rootDir":"/iplant/home",
      "zone":"iplant"
   },
   "type":"STORAGE",
   "uuid":"0001384260598633-5056a550b8-0001-006",
   "_links":{  
      "credentials":{  
         "href":"https://agave.iplantc.org/systems/v2/data.iplantcollaborative.org/credentials"
      },
      "metadata":{  
         "href":"https://agave.iplantc.org/meta/v2/data/?q={"associationIds":"0001384260598633-5056a550b8-0001-006"}"
      },
      "roles":{  
         "href":"https://agave.iplantc.org/systems/v2/data.iplantcollaborative.org/roles"
      },
      "self":{  
         "href":"https://agave.iplantc.org/systems/v2/data.iplantcollaborative.org"
      }
   }
}
```

## Storage systems  

A storage systems can be thought of as an individual data repository that you want to access through Agave. The following JSON object shows how a basic storage systems is described.

```javascript
{
   "id":"sftp.storage.example.com",
   "name":"Example SFTP Storage System",
   "type":"STORAGE",
   "description":"My example storage system using SFTP to store data for testing",
   "storage":{
      "host":"storage.example.com",
      "port":22,
      "protocol":"SFTP",
      "rootDir":"/",
      "homeDir":"/home/systest",
      "auth":{
         "username":"systest",
         "password":"changeit",
         "type":"PASSWORD"
      }
   }
}
```

The first four attribute are common to both storage and execution systems. The <code>storage</code> attribute describes the connectivity and authentication information needed to connect to the remote system. Here we describe a SFTP server accessible on <code>port</code> 22 at <code>host</code> storage.example.com. We specify that we want the <code>rootDir</code>, or virtual system root exposed through Agave, to be the system's physical root directory, and we want the authenticated user's home directory to be the <code>homeDir</code>, or virtual home directory and base of all relative paths given to Agave. Finally, we tell Agave to use password based authentication and provided the necessary credentials.

<aside class="notice">This example is given as a simple illustration of how to describe a systems for use by Agave. In most situations you should **NOT** provide your username and password. In fact, if you are using a compute or storage systems from your university or government-funded labs it is, at best, against the user agreement and, at worst, illegal to give your password to a third party service such as Agave. In these situations, use one of the many other authentication options such as SSH keys, X509 authentication, or a 3rd party authentication service like the MyProxy Gateway.</aside>

The full list of storage system attributes is described in the following table.

[table id=57 /]

### Supported data and authentication protocols  

The example above described a system accessible by SFTP. Agave supports many different data and authentication protocols for interacting with your data. Sample configurations for many protocol combinations are given below.

```shell
{
   "id":"sftp.storage.example.com",
   "name":"Example SFTP Storage System",
   "status":"UP",
   "type":"STORAGE",
   "description":"My example storage system using SFTP to store data for testing",
   "site":"example.com",
   "storage":{
      "host":"storage.example.com",
      "port":22,
      "protocol":"SFTP",
      "rootDir":"/",
      "homeDir":"/home/systest",
      "auth":{
         "username":"systest",
         "password":"changeit",
         "type":"PASSWORD"
      }
   }
}
```


[tab title="SFTP (SSH Keys)"]
```javascript
{
   "id":"sftp.storage.example.com",
   "name":"Example SFTP Storage Host",
   "status":"UP",
   "type":"STORAGE",
   "description":"My example storage system using SFTP to store data for testing",
   "site":"example.com",
   "storage":{
      "host":"texas.rangers.mlb.com",
      "port":22,
      "protocol":"SFTP",
      "rootDir":"/",
      "homeDir":"/home/nryan",
      "auth":{
         "username":"nryan",
         "publicKey": "ssh-rsa AAAAB3NzaC1yc2EBBAADAQABMQPRgQChJ6bzejqSuJdTi+VwMif8qotuSSlYwrVt0EWVduKZHpzOnS1zlknAyYXmQQFcaJ+vNAQayVMTqv+A+1lzxppTdgZ0Dn42EOYWRa6B/IEMPzDuKb7F0qNFiH9m+OZJDYdIWS1rlN1oK32jHUi0xV8kM3KOLf2TIjDBUyZRpMGyQ== Generated by Nova",
         "privateKey": "-----BEGIN RSA PRIVATE KEY-----nMIVCXAIBAAKBgQRhJ6bzejqSuJdTi+VwMif8qoyuSSlYwrVt0EWVduKZHpzOnSManlknAyYXmQQFcaJ+vNAQayVqTqv+A+1lzxppTdgZ0Dn42EOYWRa6B/IEMPzDuKb7Fn0uNFiH9x+OZJDYdIWS1rN1oK4DjHUi0xV8kMN3OPSIU23asx1UyZRpMGyQIDAQABnAoGATrW4NAkJ3Kltt6+HQ1Ir95sxFNrE6AZJaLYllke3iwPJpCX1dDdpDcXa8AGbVnjFXJUGA+dPrJqbyGCHA7E3H342837k/twSRGkcCNpRx/MMdWnw3asea/K5L4XVeunXAn79vo/e28D4Uue62dSwIvDJKIFWMSAgUoD53ImushqlLUCQQDPkObaowzkboLCnv3Nyj16KFZ5Lp7r5q5MYfRxO7t53Z7AWoflr++KrAT3UbSKtqmC68CqbPzxSd6qHnbnkWaD0HAkEAxsJZh7xorwAtdYznMFOsO0w5HDHOB7MuAnjwUvYZVaM0wA7HkE4rnH5SFAwEMlwx82OJxv83CnkRdlXOexn95rwJBALd8cnboGCd/AZzCvX2R+5K5lZtvnhLvczkWho3qrcoG/aUw4l1K78h4VFOFKMJOwv53BXQisF9kW6+qY3/XM49UCQHqDn4AYQOALvPBZCdVtPqFGg6W8csCAE7a5ud8zbj8A+6swcEB0+YcyEkvzID8en1ekmno/ET1wwRnhH6g/tdJlcCQM55QS4Z7rR4psgFDkFvA+wmxlqTGsXJD32sw15g4A0bmzSXnbfFg8TBAjGTDW7l0P8prFrtQ8Wml14390b29l1ptAyE=n-----END RSA PRIVATE KEY-----",
         "type": "SSHKEYS"
      }
   }
}
```


[tab title="SFTP (tunnel)"]
```javascript
{
   "id":"sftp.storage.example.com",
   "name":"Example SFTP Tunnel Storage Host",
   "status":"UP",
   "type":"STORAGE",
   "description":"My example storage system using SFTP via an ssh tunnel to store data for testing",
   "site":"example.com",
   "storage":{
      "host":"storage.example.com",
      "port":22,
      "protocol":"SFTP",
      "rootDir":"/",
      "homeDir":"/home/nryan",
      "auth":{
         "username":"systest",
         "password":"changeit",
         "type":"PASSWORD"
      },
      "proxy":{
         "name":"My gateway proxy server",
         "host":"proxy.example.com",
         "port":22
      }
   }
}
```


[tab title="iRODS"]
```javascript
{
   "id":"irods.storage.example.com",
   "name":"Example IRODS Storage Host",
   "status":"UP",
   "type":"STORAGE",
   "description":"My example storage system using IRODS to store data for testing",
   "site":"example.com",
   "storage":{
      "host":"storage.example.com",
      "port":1247,
      "protocol":"IRODS",
      "homeDir":"/systest",
      "rootDir":"/demoZone/home",
      "auth":{
         "username":"systest",
         "password":"changeit",
         "type":"PASSWORD"
      },
      "resource":"demoResc",
      "zone":"demoZone"
   }
}
```


[tab title="iRODS (PAM)"]
```javascript
{
   "id":"irods.storage.example.com",
   "name":"Example IRODS Storage Host",
   "status":"UP",
   "type":"STORAGE",
   "description":"My example storage system using IRODS with PAM authentication to store data for testing",
   "site":"example.com",
   "storage":{
      "host":"storage.example.com",
      "port":1247,
      "protocol":"IRODS",
      "homeDir":"/systest",
      "rootDir":"/demoZone/home",
      "auth":{
         "username":"systest",
         "password":"changeit",
         "type":"PAM"
      },
      "resource":"demoResc",
      "zone":"demoZone"
   }
}
```


[tab title="iRODS (MyProxy)"]
```javascript
{
   "id":"irods.storage.example.com",
   "name":"Example IRODS Storage Host",
   "status":"UP",
   "type":"STORAGE",
   "description":"My example storage system using IRODS to store data for testing",
   "site":"example.com",
   "storage":{
      "host":"storage.example.com",
      "port":1247,
      "protocol":"IRODS",
      "homeDir":"/systest",
      "rootDir":"/demoZone/home",
      "auth":{
         "username":"systest",
         "password":"changeit",
         "type":"X509",
         "server":{
            "name":"IRODS MyProxy Server",
            "endpoint":"myproxy.example.com",
            "port":7512,
            "protocol":"MYPROXY"
         }
      },
      "resource":"demoResc",
      "zone":"demoZone"
   }
}
```


[tab title="GridFTP"]
```javascript
{
  "id": "demo.storage.example.com",
  "name": "Demo GRIDFTP demo vm",
  "status": "UP",
  "type": "STORAGE",
  "description": "My example storage system using GridFTP to store data for testing",
  "site": "example.com",
  "storage": {
    "host": "gridftp.example.com",
    "port": 2811,
    "protocol": "GRIDFTP",
    "rootDir": "/",
    "homeDir": "/home/systest",
    "auth": {
      "credential": "-----BEGIN CERTIFICATE-----nMIIDqjCCApKgAwIBAgIDJSFGMA0GCSqGSIb3DQEBBQUAMHsxCzAJBgNVBAYTAlVTnMTgwNgYDVQQKEy9OYXRpb25hbCBDZW50ZXIgZm9yIFN1cGVyY29tcHV0aW5nIEFwncGxpY2F0aW9uczEgMB4GA1UECxMXQ2VydGlmaWNhdGUgQXV0aG9yaXRpZXMxEDAOnBgNVBAMTB015UHJveHkwHhcNMTMxMDE0MDcyMjE4WhcNMTMxMDE0MTkyNzE4WjBnnMQswCQYDVQQGEwJVUzE4MDYGA1UEChMvTmF0aW9uYWwgQ2VudGVyIGZvciBTdXBlncmNvbXB1dGluZyBBcHBsaWNhdGlvbnMxHjAcBgNVBAMTFWlwbGFudCBDb21tdW5pndHkgVXNlcjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAwfHbmtmJ1OUVwgDdn5oA8EsqihwRAi2xhZJYG/FFmOs38+0y7wTfORhVX/79XQMD3NqRJN8xhHQpmuoRynH9l9sbA9gbKaQsrpIYyExygrJ+qaZY0PccD+VAyPDjdLD86316AzWltEdV2E9b+OnCVioz62esJWSqOho8wya4Vo5svUCAwEAAaOBzjCByzAOBgNVHQ8BAf8EBAMCBLAwnHQYDVR0OBBYEFIJXT/jYmxaRywDbZudb1EXbxla5MB8GA1UdIwQYMBaAFNf8pQJ2nOvYT+iuh4OZQNccjx3tRMAwGA1UdEwEB/wQCMAAwNAYDVR0gBC0wKzAMBgorBgEEnAaQ+ZAIFMAwGCiqGSIb3TAUCAgMwDQYLKoZIhvdMBQIDAgEwNQYDVR0fBC4wLDAqnoCigJoYkaHR0cDovL2NhLm5jc2EudWl1Yy5lZHUvZjJlODlmZTMuY3JsMA0GCSqGnSIb3DQEBBQUAA4IBAQBDyW3FJ0xEIXEqk2NtiMqOM99MgufDPL0bxrR8CvPY5GRNn58EXU8RnSSJIuxL95PKclRPPOhGdB48eeF2H1MusOEUEEnHwzrZ1OUFUEpwKuqG6n0h411l3niRRx9wdJL4YITzAWZwpadzwj3d8aO9O/ttVJjGRc8A93I/d3fFAvHyvKnmlEaDrQZNBp1EtClW8xuxsfeUmyXkFlkRiKwqjkJGB8xBuzr8DfLomWq/mXaOkHznCo9nQxAs3gntszLOh+8U9aMxaeCsychRWxG3Y6Z33hrE0yz4AaVonVXu3Z7M+EN+nKbSVRblAzeKfQYYDOgsoFrugYbR9klv1so3Dt+n6n-----END CERTIFICATE-----n-----BEGIN RSA PRIVATE KEY-----nMIICWwIBAAKBgQDB8dua2YnU5RXCAN3mgDwSyqKHBECLbGFklgb8UWY6zfz7TLvBnN85GFVf/v1dAwPc2pEk3zGEdCma6hHIf2X2xsD2BsppCyukhjITHKCsn6ppljQ9xnwP5UDI8ON0sPzrfXoDNaW0R1XYT1v44JWKjPrZ6wlZKo6GjzDJrhWjmy9QIDAQABnAoGAcjrJZYMLM2FaV1G7YK/Wshq3b16JxZSoKF5U7vfihnAcuMaRL1R3IcAgfHlunIq2E7aIFnd+6sygVKXYo4alv5denekiucvKAyXK9F/VTTtLtajUnrvekLvSycKiEnbN9IgQ0ABCnlWyjgQMf64UUYBQtvU+lbRCs4jbuHxuyn5WECQQD8fJhlBHgA49hjnZBKnU9Xb+LEKhWDCEyIiOMMGY+2XhrGVvGF5KqJVusZEv8lbXNjzgSQFgLohEXVzn9v8tDFMzAkEAxKS5qCYHsTfgPlw3l1DLJRmG3SXrpevXSccBGpXQiUne9gfc9mlgnVTr5QQCXvvI673Y2LnNcnd94KEgvSrzhNwJACeS38/1g1mgXKo3ZTUUztBLinQ7sn463sQHsI6U8xGCbm/n8LMrxA8CsJadg6A6J3vdLpnm2U3YbZm1mqVhGNkQJAdsxxnoUVAdm8kWWhK6W6VG9e9I1OqdrXxfY/tecsyjg6D1a1Qb8mfuj4DoaKjCme69To8nZ3moZXRBWkypzYQopwJAB/zr1UpFz6vY4sIm3Gw3ll/ruNGCr2dzjTyLSGglCOf0nUljJ1FGLyW647JzGPMLcfdb0iEexzCEii9YUFUN1Ow==n-----END RSA PRIVATE KEY-----",
      "type": "X509"
    }
  }
}
```


[tab title="GridFTP (MyProxy)"]
```javascript
{
  "id": "demo.storage.example.com",
  "name": "Demo GRIDFTP + MyProxy Storage System",
  "status": "UP",
  "type": "STORAGE",
  "description": "My example storage system using GridFTP with MyProxy to store data for testing",
  "site": "example.com",
  "storage": {
    "host": "gridftp.example.com",
    "port": 2811,
    "protocol": "GRIDFTP",
    "rootDir": "/",
    "homeDir": "/home/systest",
    "auth": {
      "username": "systest",
      "password": "changeit",
      "type": "X509",
      "server": {
        "name": "XSEDE MyProxy Server",
        "endpoint": "myproxy.example.com",
        "port": 7512,
        "protocol": "MYPROXY"
      }
    }
  }
}
```


[tab title="GridFTP (MyProxy Gateway)"]
```javascript
{
  "id": "demo.storage.example.com",
  "name": "Demo GRIDFTP + MyProxy Storage System",
  "status": "UP",
  "type": "STORAGE",
  "description": "My example storage system using GridFTP with MyProxy to store data for testing",
  "site": "example.com",
  "storage": {
    "host": "gridftp.example.com",
    "port": 2811,
    "protocol": "GRIDFTP",
    "rootDir": "/",
    "homeDir": "/home/systest",
    "auth": {
      "type": "X509",
      "server": {
        "name": "My Trusted MPG Server",
        "endpoint": "https://api.example.com/myproxy/v2/",
        "port": 443,
        "protocol": "MPG"
      }
    }
  }
}
```


[tab title="LOCAL"]
```javascript
{
   "id":"local.storage.example.com",
   "name":"Example LOCAL Storage Host",
   "status":"UP",
   "type":"STORAGE",
   "description":"My example storage system using the local file system to store data for testing",
   "site":"example.com",
   "storage":{
      "host":"localhost",
      "protocol":"LOCAL",
      "rootDir":"/",
      "homeDir":"/home/systest"
   }
}
```


[tab title="Amazon S3"]
```javascript
{
   "id":"demo.storage.example.com",
   "name":"Example Amazon S3 Storage System",
   "status":"UP",
   "type":"STORAGE",
   "description":"My example storage system using Amazon S3 to store data for testing",
   "site":"aws.amazon.com",
   "storage":{
      "host": "s3-website-us-east-1.amazonaws.com",
      "port": 443,
      "protocol": "S3",
      "homeDir": "/",
      "rootDir": "/",
      "container": "mybucket",
      "auth": {
          "publicKey": "AKCA...1RCF",
          "privateKey": "8xj3...g/4+",
          "type": "APIKEYS"
      }
   }
}
```


[/tabgroup]

In each of the examples above, the <code>storage</code> objects were slightly different, each unique to the protocol used. Descriptions of every attribute in the <code>storage</code> object and its children are given in the following tables.

<code>storage</code> attributes give basic connectivity information describing things like how to connect to the system and on what port.

[table id=58 /]

<code>storage.auth</code> attributes give authentication information describing how to authenticate to the system specified in the <code>storage</code> config above.

[table id=59 /]

<code>storage.auth.server</code> attributes give information about how to obtain a credential that can be used in the authentication process. Currently only systems using the X509 authentication can leverage this feature to communicate with <a href="http://grid.ncsa.illinois.edu/myproxy/" title="MyProxy Server" target="_blank">MyProxy</a> and <a href="https://bitbucket.org/taccaci/myproxy-gateway" title="MyProxy Gateway" target="_blank">MyProxy Gateway</a> servers.

[table id=61 /]

<code>system.proxy</code> configuration attributes give information about how to connect to a remote system through a proxy server. This often happens when the target system is behind a firewall or resides on a NAT. Currently proxy servers can only reuse the authentication configuration provided by the target system.

[table id=60 /]

<aside class="notice">If you have not yet set up a system of your own, now is a good time to grab a sandbox system to use while you follow along with the rest of this tutorial.</aside>

### Creating a new storage system  

```shell
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" -F "fileToUpload=@sftp-password.json" https://$API_BASE_URL/systems/$API_VERSION
```


```cli
systems-addupdate -v -F sftp-password.json
```


The response from the service will be similar to the following:

[code lang="js" highlight="3,5,8-11,17-20,22" firstline="1" light="false"]
{
    "id" : "demo.storage.example.com",
    "uuid" : "0001411321620333-b0b0b0bb0b-0001-006",
    "name" : "Example SFTP Storage System",
    "status" : "UP",
    "type" : "STORAGE",
    "description" : "My example storage system using SFTP to store data for testing",
    "site" : null,
    "revision" : 1,
    "public" : false,
    "lastModified" : "2014-09-21T14:50:35.268-05:00",
    "storage" : {
      "host" : "storage.example.com",
      "port" : 22,
      "protocol" : "SFTP",
      "rootDir" : "/",
      "homeDir" : "/home/systest",
      "publicAppsDir" : null,
      "mirror" : false,
      "proxy" : null,
      "auth" : {
        "type" : "PASSWORD"
      }
    }
}
```

Congratulations, you just added your first system. This storage system can now be used by the <a title="File Management" href="http://agaveapi.co/documentation/tutorials/data-management/">Files service</a> to manage data, the Transfer service as a source or destination of data movement, the Apps service as a application repository, and the <a title="Job Submission" href="http://agaveapi.co/documentation/tutorials/job-managment/">Jobs Service</a> as both a staging and archiving destination.

Notice that the JSON returned from the Systems service is different than what was submitted. Several fields have been added, and several other have been removed. On line 3, the UUID of the system has been added. This is the same UUID that is used in notifications and metadata references. On line 5, the <code>status</code> value was added in and assigned a default value since we did not specify it. Ditto for the <code>site</code> attribute on line 8.

Three new fields were added on lines 9-11. <code>revision</code> is the number of times this system has been updated. This being our first time registering the system, it is set to <em>1</em>. <code>public</code> tells whether this system is published as a shared resource for all users. We will cover this more in the section on System scope. <code>lastModified</code> is a timestamp of the last time the system was updated.

In the <code>storage</code> object, the <code>publicAppsDir</code> and <code>mirror</code> fields were both added and set to their default values. In this example we are not using a <code>proxy</code> server, so it was defaulted to <em>null</em>. Last, and most important, all authentication information has been omitted from the response object. Regardless of the authentication type, no user credential information will ever be returned once they are stored.

## Execution Systems  

In contrast to storage systems, execution systems specify compute resources where application binaries can be run. In addition to the <code>storage</code> attribute found in storage systems, execution systems also have a <code>login</code> attribute describing how to connect to the remote system to submit jobs as well as several other attributes that allow Agave to determine how to stage data and run software on the system. The full list of execution system attributes is given in the following tables.

[table id=49 /]

### Schedulers and system execution types  

Agave supports job execution both interactively and through <a href="http://en.wikipedia.org/wiki/Job_scheduler" title="Job Scheduler" target="_blank">batch queueing systems</a> (aka schedulers). We cover the mechanics of job submission in the Job Management tutorial. Here we just point out that regardless of how your job is actually run on the underlying system, the process of submitting, monitoring, sharing, and otherwise interacting with your job through Agave is identical. Describing the scheduler and execution types for your system is really just a matter of picking the most efficient and/or available mechanism for running jobs on your system.

As you saw in the table above, <code>executionType</code> refers to the classification of jobs going into the system and <code>scheduler</code> refers to the type of batch scheduler used on a system. These two fields help limit the range of job submission options used on a specific system. For example, it is not uncommon for a HPC system to accept jobs from both a Condor scheduler and a batch scheduler. It is also possible, though generally discouraged, to fork jobs directly on the command line. With so many options, how would users publishing apps on such a system know what mechanism to use? Specifying the execution type and scheduler help narrow down the options to a single execution mechanism.

Thankfully, picking the right combination is pretty simple. The following table illustrates the available combinations.

[table id=63 /]

<aside class="notice">When you are describing your system, consider the policies put in place by your system administrators. If the system you are defining has a scheduler, chances are they want you to use it.</aside>

### Defining batch queues <a name="defining-batch-queues">&nbsp;</a>  

Agave supports the notion of multiple submit queues. On HPC systems, queues should map to actual batch scheduler queues on the target server. Additionally, queues are used by Agave as a mechanism for implementing quotas on job throughput in a given queue or across an entire system. Queues are defined as a JSON array of objects assigned to the <code>queues</code> attribute. The following table summarizes all supported queue parameters.

[table id=48 /]

### Configuring quotas  

In the batch queues table above, several attributes exist to specify limits on the number of total jobs and user jobs in a given queue. Corresponding attributes exist in the execution system to specify limits on the number of total and user jobs across an entire system. These attributes, when used appropriately, can be used to tell Agave how to enforce limits on the concurrent activity of any given user. They can also ensure that Agave will not unfairly monopolize your systems as your application usage grows.

If you have ever used a shared HPC system before, you should be familiar with batch queue quotas. If not, the important thing to understand is that they are a critical tool to ensure fair usage of any shared resource. As the owner/administrator for your registered system, you can use the batch queues you define to enforce whatever usage policy you deem appropriate.

Consider one example where you are using a VM to run image analysis routines on demand through Agave, your server will become memory bound and experience performance degradation if too many processes are running at once. To avoid this, you can set a limit using a batch queue configuration that limits the number of simultaneous tasks that can run at once on your server.

Another example where quotas can be helpful is to help you properly partitioning your system resources. Consider a user analyzing unstructured data. The problem is computationally and memory intensive. To preserve resources, you could create one queue with a moderate value of <code>maxJobs</code> and conservative <code>maxMemoryPerNode</code>, <code>maxProcessorsPerNode</code>, and <code>maxNodes</code> values to allow good throughput of small job. You could then create another queue with large <code>maxMemoryPerNode</code>, <code>maxProcessorsPerNode</code>, and <code>maxNodes</code> values while only allowing a single job to run at a time. This gives you both high throughput and high capacity on a single system.

The following sample queue definitions illustrate some other interesting use cases.

```shell
```javascript
{  
    "name":"short_job",
    "maxJobs":100,
    "maxUserJobs":10,
    "maxNodes":32,
    "maxMemoryPerNode":"64GB",
    "maxProcessorsPerNode":12,
    "maxRequestedTime":"00:15:00",
    "customDirectives":null,
    "default":true
}
```


[tab title="Small queues"]
Restrict the queue to having at most 10 total jobs in it at once. Jobs may run for no more than an hour.
```javascript
{  
    "name":"small_q",
    "maxJobs":10,
    "maxUserJobs":1,
    "maxNodes":32,
    "maxMemoryPerNode":"64GB",
    "maxProcessorsPerNode":12,
    "maxRequestedTime":"01:00:00",
    "customDirectives":null,
    "default":true
}
```


[tab title="Single node"]
Restrict the queue to only running single node jobs.
```javascript
{  
    "name":"short_job",
    "maxJobs":100,
    "maxUserJobs":10,
    "maxNodes":1,
    "maxMemoryPerNode":"64GB",
    "maxProcessorsPerNode":12,
    "maxRequestedTime":"24:00:00",
    "customDirectives":null,
    "default":true
}
```


[tab title="Dedicated queues"]
Create two queues. "big_mem" allows single node jobs with memory up to 1TB. "big_compute" allows jobs with up to 256 nodes, and 16GB of memory per node.
```javascript
[
  {  
    "name":"big_mem",
    "maxJobs":10,
    "maxUserJobs":1,
    "maxNodes":1,
    "maxMemoryPerNode":"1TB",
    "maxProcessorsPerNode":12,
    "maxRequestedTime":"12:00:00",
    "customDirectives":null,
    "default":true
  },
  {  
    "name":"big_compute",
    "maxJobs":10,
    "maxUserJobs":10,
    "maxNodes":256,
    "maxMemoryPerNode":"16GB",
    "maxProcessorsPerNode":12,
    "maxRequestedTime":"24:00:00",
    "customDirectives":null,
    "default":true
  }
]
```


[/tabgroup]

### System login protocols  

As with storage systems, Agave supports several different protocols and mechanisms for job submission. We already covered scheduler and queue support. Here we illustrate the different login configurations possible. For brevity, only the value of the <code>login</code> JSON object is shown.

```shell
{  
   "host":"execute.example.com",
   "port":2222,
   "protocol":"GSISSH",
   "auth":{  
      "credential": "-----BEGIN CERTIFICATE-----nMIIDqjCCApKgAwIBAgIDJSFGMA0GCSqGSIb3DQEBBQUAMHsxCzAJBgNVBAYTAlVTnMTgwNgYDVQQKEy9OYXRpb25hbCBDZW50ZXIgZm9yIFN1cGVyY29tcHV0aW5nIEFwncGxpY2F0aW9uczEgMB4GA1UECxMXQ2VydGlmaWNhdGUgQXV0aG9yaXRpZXMxEDAOnBgNVBAMTB015UHJveHkwHhcNMTMxMDE0MDcyMjE4WhcNMTMxMDE0MTkyNzE4WjBnnMQswCQYDVQQGEwJVUzE4MDYGA1UEChMvTmF0aW9uYWwgQ2VudGVyIGZvciBTdXBlncmNvbXB1dGluZyBBcHBsaWNhdGlvbnMxHjAcBgNVBAMTFWlwbGFudCBDb21tdW5pndHkgVXNlcjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAwfHbmtmJ1OUVwgDdn5oA8EsqihwRAi2xhZJYG/FFmOs38+0y7wTfORhVX/79XQMD3NqRJN8xhHQpmuoRynH9l9sbA9gbKaQsrpIYyExygrJ+qaZY0PccD+VAyPDjdLD86316AzWltEdV2E9b+OnCVioz62esJWSqOho8wya4Vo5svUCAwEAAaOBzjCByzAOBgNVHQ8BAf8EBAMCBLAwnHQYDVR0OBBYEFIJXT/jYmxaRywDbZudb1EXbxla5MB8GA1UdIwQYMBaAFNf8pQJ2nOvYT+iuh4OZQNccjx3tRMAwGA1UdEwEB/wQCMAAwNAYDVR0gBC0wKzAMBgorBgEEnAaQ+ZAIFMAwGCiqGSIb3TAUCAgMwDQYLKoZIhvdMBQIDAgEwNQYDVR0fBC4wLDAqnoCigJoYkaHR0cDovL2NhLm5jc2EudWl1Yy5lZHUvZjJlODlmZTMuY3JsMA0GCSqGnSIb3DQEBBQUAA4IBAQBDyW3FJ0xEIXEqk2NtiMqOM99MgufDPL0bxrR8CvPY5GRNn58EXU8RnSSJIuxL95PKclRPPOhGdB48eeF2H1MusOEUEEnHwzrZ1OUFUEpwKuqG6n0h411l3niRRx9wdJL4YITzAWZwpadzwj3d8aO9O/ttVJjGRc8A93I/d3fFAvHyvKnmlEaDrQZNBp1EtClW8xuxsfeUmyXkFlkRiKwqjkJGB8xBuzr8DfLomWq/mXaOkHznCo9nQxAs3gntszLOh+8U9aMxaeCsychRWxG3Y6Z33hrE0yz4AaVonVXu3Z7M+EN+nKbSVRblAzeKfQYYDOgsoFrugYbR9klv1so3Dt+n6n-----END CERTIFICATE-----n-----BEGIN RSA PRIVATE KEY-----nMIICWwIBAAKBgQDB8dua2YnU5RXCAN3mgDwSyqKHBECLbGFklgb8UWY6zfz7TLvBnN85GFVf/v1dAwPc2pEk3zGEdCma6hHIf2X2xsD2BsppCyukhjITHKCsn6ppljQ9xnwP5UDI8ON0sPzrfXoDNaW0R1XYT1v44JWKjPrZ6wlZKo6GjzDJrhWjmy9QIDAQABnAoGAcjrJZYMLM2FaV1G7YK/Wshq3b16JxZSoKF5U7vfihnAcuMaRL1R3IcAgfHlunIq2E7aIFnd+6sygVKXYo4alv5denekiucvKAyXK9F/VTTtLtajUnrvekLvSycKiEnbN9IgQ0ABCnlWyjgQMf64UUYBQtvU+lbRCs4jbuHxuyn5WECQQD8fJhlBHgA49hjnZBKnU9Xb+LEKhWDCEyIiOMMGY+2XhrGVvGF5KqJVusZEv8lbXNjzgSQFgLohEXVzn9v8tDFMzAkEAxKS5qCYHsTfgPlw3l1DLJRmG3SXrpevXSccBGpXQiUne9gfc9mlgnVTr5QQCXvvI673Y2LnNcnd94KEgvSrzhNwJACeS38/1g1mgXKo3ZTUUztBLinQ7sn463sQHsI6U8xGCbm/n8LMrxA8CsJadg6A6J3vdLpnm2U3YbZm1mqVhGNkQJAdsxxnoUVAdm8kWWhK6W6VG9e9I1OqdrXxfY/tecsyjg6D1a1Qb8mfuj4DoaKjCme69To8nZ3moZXRBWkypzYQopwJAB/zr1UpFz6vY4sIm3Gw3ll/ruNGCr2dzjTyLSGglCOf0nUljJ1FGLyW647JzGPMLcfdb0iEexzCEii9YUFUN1Ow==n-----END RSA PRIVATE KEY-----",
      "type": "X509"
   }
}
```


[tab title="GSISSH (MyProxy)"]
```javascript
{  
   "host":"execute.example.com",
   "port":2222,
   "protocol":"GSISSH",
   "auth":{  
      "username":"systest",
      "password":"changeit",
      "credential":"",
      "type":"X509",
      "server":{
        "name":"IRODS MyProxy Server",
        "endpoint":"myproxy.example.com",
        "port":7512,
        "protocol":"MYPROXY"
      }
   }
}
```


[tab title="GSISSH (MPG)"]
```javascript
{  
   "host":"execute.example.com",
   "port":2222,
   "protocol":"GSISSH",
   "auth":{  
      "username":"systest",
      "type":"X509",
      "server": {
        "name": "My Trusted MPG Server",
        "endpoint": "https://api.example.com/myproxy/v2/",
        "port": 443,
        "protocol": "MPG"
      }
   }
}
```


[tab title="SSH"]
```javascript
{
  "host": "execute.example.com",
  "port": 22,
  "protocol": "SSH",
  "auth": {
    "username": "systest",
    "password": "changeit",
    "type": "PASSWORD"
  }
}
```


[tab title="SSH (tunnel)"]
```javascript
{
  "host":"execute.example.com",
  "port":22,
  "protocol":"SSH",
  "auth":{
    "username":"systest",
    "password":"changeit",
    "type":"PASSWORD"
  },
  "proxy":{
    "name":"My gateway proxy server",
    "host":"proxy.example.com",
    "port":"22"
  }
}
```


[tab title="LOCAL"]
```javascript
{
  "host": "localhost",
  "protocol": "LOCAL",
  "auth": {
    "type": "LOCAL"
  }
}
```


[/tabgroup]

The full list of login configuration options is given in the following table. We omit the <code>login.auth</code> and <code>login.proxy</code> attributes as they are identical to those used in the storage config.

[table id=62 /]

### Scratch and work directories  

In the Job Management tutorial we will dive into how Agave manages the end-to-end lifecycle of running a job. Here we point out two relevant attributes that control where data is staged and where your job will physically run. The <code>scratchDir</code> and <code>workDir</code> attributes control where the working directories for each job will be created on an execution system. The following table summarizes the decision making process Agave uses to determine where the working directories should be created.

[table id=52 /]

While it is not required, it is a best practice to always specify <code>scratchDir</code> and <code>workDir</code> values for your execution systems and, whenever possible, place them outside of the system <code>homeDir</code> to ensure data privacy. The reason for this is that the file system available on many servers is actually made up of a combination of physically attached storage, mounted volumes, and network mounts. Often times, your home directory will have a very conservative quota while the mounted storage will essentially be quota free. As the above table shows, when you do not specify a <code>scratchDir</code> or <code>workDir</code>, Agave will attempt to create your job work directories in your system <code>homeDir</code>. It is very likely that, in the course of running simulations, you will reach the quota on your home directory, thereby causing that job and all future jobs to fail on the system until you clear up more space. To avoid this, we recommend specifying a location with sufficient available space to handle the work you want to do.

Another common error that arises from not specifying thoughtful <code>scratchDir</code> and <code>workDir</code> values for your execution systems is jobs failing due to "permission denied" errors. This often happens when your <code>scratchDir</code> and/or <code>workDir</code> resolve to the actual system root. Usually the account you are using to access the system will not have permission to write to <code>/</code>, so all attempts to create a job working directory fail, accurately, due to a "permission denied" error.

<aside class="notice">While it is not required, it is a best practice to always specify `scratchDir` and `workDir` values for your execution systems and, whenever possible, place them outside of the system `homeDir` to ensure data privacy.</aside>

### Creating a new execution system  

```shell
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" -F "fileToUpload=@ssh-password.json" https://$API_BASE_URL/systems/$API_VERSION
```


```cli
systems-addupdate -v -F ssh-password.json
```


The response from the server will be similar to the following.

```javascript
{  
   "id":"demo.execute.example.com",
   "uuid":"0001323106792914-5056a550b8-0001-006",
   "name":"Example SSH Execution Host",
   "status":"UP",
   "type":"EXECUTION",
   "description":"My example system using ssh to submit jobs used for testing.",
   "site":"example.com",
   "revision":1,
   "public":false,
   "lastModified":"2013-07-02T10:16:11.000-05:00",
   "executionType":"HPC",
   "scheduler":"SGE",
   "environment":null,
   "startupScript":"./bashrc",
   "maxSystemJobs":100,
   "maxSystemJobsPerUser":10,
   "workDir":"/work",
   "scratchDir":"/scratch",
   "queues":[  
      {  
         "name":"normal",
         "maxJobs":100,
         "maxUserJobs":10,
         "maxNodes":32,
         "maxMemoryPerNode":"64GB",
         "maxProcessorsPerNode":12,
         "maxRequestedTime":"48:00:00",
         "customDirectives":null,
         "default":true
      },
      {  
         "name":"largemem",
         "maxJobs":25,
         "maxUserJobs":5,
         "maxNodes":16,
         "maxMemoryPerNode":"2TB",
         "maxProcessorsPerNode":4,
         "maxRequestedTime":"96:00:00",
         "customDirectives":null,
         "default":false
      }
   ],
   "login":{  
      "host":"texas.rangers.mlb.com",
      "port":22,
      "protocol":"SSH",
      "proxy":null,
      "auth":{  
         "type":"PASSWORD"
      }
   },
   "storage":{  
      "host":"texas.rangers.mlb.com",
      "port":22,
      "protocol":"SFTP",
      "rootDir":"/home/nryan",
      "homeDir":"",
      "proxy":null,
      "auth":{  
         "type":"PASSWORD"
      }
   }
}
```

## System roles  

Systems you register are private to you and you alone. You can, however, allow other Agave clients to utilize the system you define by granting them a role on the system using the systems roles services. The available roles are given in the table below.

[table id=51 /]

<aside class="notice">Please see the Systems Roles tutorial for a deep discussion of system roles and how they are used.</aside>

## Cloning systems  

Sharing systems through the use of roles allows other people to run jobs and access data on that system. When that happens, the users to whom you granted roles are accessing the system under your account. While they do <em>NOT</em> have access to your credentials, they do have access to the system using whatever account you use to authenticate. In most situations, this is not a problem. It is not uncommon to use a shared (or community account) within an application. However sometimes it is preferable for users to use their own account rather than yours. One way to do this is to simply re-send the same system description with a different ID. Another is to use the cloning feature of the Systems service.

Cloning an existing system will create a new system, with a new id, and all attributes copied over with the exception of the original system's authentication information and roles. You will be assigned owner of the system clone, but will still need to add your own credentials in order to do anything useful.

To clone a system, you make a PUT request on the system's url and pass it a new system id.

```shell
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" -X PUT -d "action=clone&amp;id=systest.demo.clone" https://$API_BASE_URL/systems/$API_VERSION/$SYSTEM_ID
```


```cli
systems-clone -v -I systest.demo.clone $SYSTEM_ID
```


## System scope  

Throughout these tutorials and <a href="http://agaveapi.co/documentation/beginners-guides/" title="Beginner’s Guides">Beginner's Guides</a>, we have referred to both public and private systems. In addition to roles, systems have a concept of scope associated with them. Not to be confused with OAuth scope mentioned in the <a href="http://agaveapi.co/documentation/authorization/" title="Authorization Guide">Authentication Guide</a>, system scope refers to the availability of a system to the general user community. The following table lists the available scopes and their meanings.

[table id=53 /]

### Private systems  

All systems are private by default. This means that no one can use a system you register without you or another user with "admin" permissions granting them a role on that system. Most of the time, unless you are configuring a tenant for your organization, all the systems you register will stay private. Do not mistake the term private for isolated. Private simply means not public. Another way to think of private systems is as "invitation only." You are free to share your system as many or as few people as you want and it will still remain a private system.

### Readonly systems  

Readonly systems are systems who have granted a GUEST role to the <code>world</code> group. Once this grant is made, any user will be able to browse the system's entire file system regardless of individual permissions. Be careful when making a system readonly. Usually, the only reason you would do this is because you have configured the system <code>rootDir</code> to point to a dataset or volume that you want to publish for others to use. Carelessly making systems readonly can expose personal data stored on the system to every other API user. While your intentions may be pure, theirs may not be, so think through the implications of this action before you take it.

### Public systems  

Public systems are available for use by every API user within your tenant. Once public, systems inherit specific behavior unique to their <code>type</code>. We will cover each system type in turn.

#### Public Storage Systems  

Public storage systems enforce a virtual user home directory with implied user permissions. The following table gives a brief summary of the permission implications. You can read more about data permissions in the <a href="http://agaveapi.co/documentation/tutorials/data-management-tutorial/data-permissions-tutorial/" title="Data Permissions Tutorial">Data Permissions</a> tutorial.

[table id=54 /]

Notice in the above example that on public systems, users will have implied ownership of a folder matching their username in the system's <code>homeDir</code>. In the table, this means that user "systest" will have ownership of the physical home directory <code>/home/systest</code> on the system after it's public. It is important that, before publishing a system, you make sure that the account used to access the system can actually write to these folders. Otherwise, users will not be able to access their data on the system you make public.

<aside class="notice">Before making a system public, make sure that you have a strategy for mapping API users to directories on the system you want to expose. If mapping to the `/home` folder on a Unix system, make sure the account used to access the system has write access to all user directories.</aside>

#### Public Execution Systems  

Public execution systems do not share the same behavior as public storage systems. Unless explicit permission has been given, public execution systems are not accessible for data access by non-privileged users. This is because public systems allow all users to run applications on them and granting public access to the file system would expose user job data to all users. If you do need to expose the data on a public execution system, either register it again as a storage system (using an appropriate <code>rootDir</code> outside of the system <code>scratchDir</code> and <code>workDir</code> paths), or grant specific users a role on the system.

#### Publishing a system  

To publish a system and make it public, you make a PUT request on the system's url.

```shell
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" -X PUT -d "action=publish" https://$API_BASE_URL/systems/$API_VERSION/$SYSTEM_ID
```


```cli
systems-publish -v $SYSTEM_ID
```


The response from the service will be the same system description we saw before, this time with the public attribute set to <em>true</em>.

To unpublish a system, make the same request with the <code>action</code> attribute set to <em>unpublish</em>.

```shell
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" -X PUT -d "action=unpublish" https://$API_BASE_URL/systems/$API_VERSION/$SYSTEM_ID
```


```cli
systems-unpublish -v $SYSTEM_ID
```


## Default systems  

As you continue to use Agave over time, it will not be uncommon for you to accumulate additional storage and execution systems through both self-registration and other people sharing their systems with you. It may even be the case that you have multiple public systems available to you. In this situation, it is helpful for both you and your users to specify what the default systems should be.

Default systems are the systems that are used when the user does not specify a system to use when performing a remote action in Agave. For example, specifying an <code>archivePath</code> in a job request, but no <code>archiveSystem</code>, or specifying a <code>deploymentPath</code> in an app description, but no <code>deploymentSystem</code>. In these situations, Agave will use the user's default storage system.

Four types of default systems are possible. The following table describes them.

[table id=55 /]

<aside class="notice">As a best practice, it is recommended to always specify the system you intend to use when interacting with Agave. This will eliminate ambiguity in each request and make your actions more repeatable over time as the availability and configuration of the global and user default systems may change.</aside>

### Setting user default system  

To set a system as the user's default, you make a PUT request on the system's url. Only systems the user has access to may be used as their default.

```shell
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" -X PUT -d "action=setdefault" https://$API_BASE_URL/systems/$API_VERSION/$SYSTEM_ID
```


```cli
systems-setdefault -v $SYSTEM_ID
```


The response from the service will be the same system description we saw before, this time with the <code>default</code> attribute set to <em>true</em>.

### Unsetting user default system  

To remove a system as the user's default, make the same request with the <code>action</code> attribute set to <em>unsetDefault</em>. Keep in mind that you cannot remove the global default system from being the user's default. You can only set a different one to replace it.

```shell
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" -X PUT -d "action=unsetDefault" https://$API_BASE_URL/systems/$API_VERSION/$SYSTEM_ID
```


```cli
systems-unsetdefault -v $SYSTEM_ID
```


### Setting global default system  

Tenant administrators may wish to set default storage and execution systems for an entire tenant. These are called global default systems. There may be at most one system of each type set as a global default. To set a global default system, first make sure that the system is public. Only public systems may be set as a global default. Next, make sure you have administrator permissions for your tenant. Only tenant admins may publish systems and manage the global defaults. Lastly, make a PUT request on the system's url with an <code>action</code> attribute in the body set to <em>unsetGlobalDefault</em>.

```shell
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" -X PUT -d "action=setglobaldefault" https://$API_BASE_URL/systems/$API_VERSION/$SYSTEM_ID
```


```cli
systems-setdefault -v -G $SYSTEM_ID
```


The response from the service will be the same system description we saw before, this time with both the <code>default</code> and <code>public</code> attributes set to <em>true</em>.

<aside class="notice">Setting global default systems does not preclude users from manually setting their own default systems. Any user-defined default systems will trump the global default system setting for that user.</aside>

To remove a system from being the global default, make the same request with the <code>action</code> attribute set to <em>unsetGlobalDefault</em>.

```shell
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" -X PUT -d "action=unsetGlobalDefault" https://$API_BASE_URL/systems/$API_VERSION/$SYSTEM_ID
```


```cli
systems-unsetdefault -v -G $SYSTEM_ID
```


This time the response from the service will have <code>default</code> set to <em>false</em> and <code>public</code> set to <em>true</em>.

## Deleting systems  

In the event you wish to permanently delete a system, you can make a DELETE request on the system URL.

```shell
curl -sk -H "Authorization: Bearer $ACCESS_TOKEN" -X DELETE https://$API_BASE_URL/systems/$API_VERSION/$SYSTEM_ID
```


```cli
systems-delete $SYSTEM_ID
```


The call will return an empty result.

Deleting a system will disable the system and all applications published on that system from use. Any running jobs will be killed, and any data archived on that system will no longer be available. There is no way to restore a system once it is deleted, and the system id cannot be reused in the future, so use this operation with care.

<aside class="notice">If you simply wish to remove a system from service, you can update the system `status` or `available` attributes depending on whether you want to disable user or visibility.</aside>

## Multi-user environments  

If your application supports a multi-user environment and those users do not have API accounts, then you may run into a situation where you are juggling multiple user credentials for a single system. Agave has a solution for this problem in the for of its Internal User feature. You can map your application users into a private user store Agave provides you and assign those users credentials on your systems. This allows you to move seamlessly from community users to private users and back without having to alter your application code. For a deep discussion on the mechanics and implications of credential management with internal users, see the <a href="http://agaveapi.co/documentation/tutorials/system-management/internal-user-credential-management/" title="Internal User Credential Management">Internal User Credential Management</a> tutorial.