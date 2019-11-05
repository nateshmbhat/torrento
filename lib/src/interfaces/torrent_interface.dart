import 'package:test/test.dart';
import 'package:torrent_api/src/exceptions/InvalidParameterException.dart' as prefix0;

abstract class ICommonTorrentFunctions {
  Future<bool> login(String username , String password) ; //return true if login success
  Future<bool> logout() ; //return true if success 
  void resume(String torrentHash) ; 
  void pause(String torrentHash) ; 
  void stop(String torrentHash) ; 
  void remove(String torrentHash); 

  void recheck(String torrentHash); 

  void startMultiple(List<String>torrentHashes) ; 
  void recheckMultiple(List<String>torrentHashes) ; 
  void removeMultiple(List<String>torrentHashes) ;
  void resumeMultiple(List<String>torrentHashes) ; 
  void stopMultiple(List<String>torrentHashes) ; 
} 

abstract class IQbitTorrentApi extends ICommonTorrentFunctions{

}

abstract class IUTorrentApi extends ICommonTorrentFunctions{

}