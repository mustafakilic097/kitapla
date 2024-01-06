
import '../model/group_model.dart';
import '../model/user_group_model.dart';
import '../model/user_model.dart';

class UserGroupRepository{

  List<UserGroupModel> usergroups = [
    UserGroupModel("1", "01", "yönetici"),
    UserGroupModel("1", "02", "yönetici"),
    UserGroupModel("2", "01", "normal"),
    UserGroupModel("3", "02", "normal"),
    UserGroupModel("3", "01", "normal"),
    UserGroupModel("4", "01", "normal"),
    UserGroupModel("5", "01", "normal"),
    UserGroupModel("6", "01", "normal"),
    UserGroupModel("7", "01", "normal"),
    UserGroupModel("8", "01", "normal"),
    UserGroupModel("9", "01", "normal"),
    UserGroupModel("10", "01", "normal"),
  ];

  List<UserModel> getUsersAtGroup(String groupId){
    List<UserModel> users = [];
    for (var usergroup in usergroups) {
      if(usergroup.groupId==groupId){
        // UserModel? user = UserRepository().getUser(usergroup.userId);
        // if(user!=null){
        //   users.add(user);
        // }
      }
    }
    return users;
  }

  List<GroupModel> getGroupsDataFromUserId(String userId){
    List<GroupModel> groups = [];
    for (var usergroup in usergroups) {
      if(usergroup.userId==userId){
        // var group = GroupRepository().getLocalGroupData(usergroup.groupId);
        // groups.add(group);
      }
    }
    return groups;
  }

}

// final userGroupRepositoryProvider = ChangeNotifierProvider((ref) => UserGroupRepository());