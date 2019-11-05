import 'package:test/test.dart';
import 'package:torrent_api/src/exceptions/exceptions.dart' as prefix0;

abstract class ICommonTorrentFunctions {
  Future login(String username , String password) ; //return true if login success
  Future logout() ; //return true if success 
  Future start(String torrentHash) ; 
  Future pause(String torrentHash) ; 
  Future stop(String torrentHash) ; 
  Future resume(String torrentHash) ; 
  Future remove(String torrentHash); 
  Future recheck(String torrentHash) ; 

  Future startMultiple(List<String>torrentHashes) ; 
  Future pauseMultiple(List<String>torrentHashes) ; 
  Future recheckMultiple(List<String>torrentHashes) ; 
  Future removeMultiple(List<String>torrentHashes) ;
  Future resumeMultiple(List<String>torrentHashes) ; 
  Future stopMultiple(List<String>torrentHashes) ; 
} 

abstract class IQbitTorrentApi extends ICommonTorrentFunctions{

}

abstract class IUTorrentApi extends ICommonTorrentFunctions{

}