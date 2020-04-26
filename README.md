
<p align="center">
<img width="150" src="https://i.imgur.com/j7KnjvG.png"/>
</p>

# Torrento

**Torrento** is an api wrapper for many popular torrent clients and helps in **remotely controlling** and **managing torrent clients**.


## Features : 
+ Login to your torrent client remotely and control it.

+ Browse your active torrents.
+ Start , Stop , Pause and Resume your torrents.
+ Get information and Stats on all your torrents.
+ **Add** new torrents or **Remove** existing ones.
+ **Get** and **Set** individual torrent properties.
+ Setting upload and download speed limits.
+ Some torrent client specific features like : 
    + Get and Set **Save Path** of torrents.

    + Shutdown application
    + Control torrent peers , trackers  , transfer info
    + Control priority of torrents , individual files.
    + Create or Remove **Tags** and **Categories**

### Supported Torrent Clients : 
+ &mu;Torrent
+ BitTorrent
+ qBittorrent


## Installation : 
Add the `torrento` package as dependency in your `pubspec.yaml`

```dart
dependencies:
  torrento:
```

## Usage :

Here's a sample of some of the methods that are available to use.

#### Small Example : 

```dart
import 'package:torrento/torrento.dart';

QbitTorrentController obj = QbitTorrentController('192.168.0.101' , 8080) ; 
await obj.logIn('username' , 'password') ; 

await obj.addTorrent('magnet:?xt=urn:btih:0d18397945bcc9f495818aa2c823ab167dc8da5c&dn=The.Lion.King.2019.1080p.BluRay.H264.AAC-RARBG') ; 

var torrents = await obj.getTorrentsList(filter: TorrentFilter.paused) ; 

torrents.forEach((t)=>print('${t['name']} : ${t['hash']}')) ; 

print("Starting all torrents") ;
await obj.startAllTorrents() ; 

print(await obj.getVersion()) ; 

await obj.logOut() ; 

```

## Links : 
+ [Torrento Docs](https://pub.dev/documentation/torrento/latest/torrento/torrento-library.html)
+ [Pub Dev Site](https://pub.dev/packages/torrento)
+ [Home Page](https://github.com/nateshmbhat/torrento)



