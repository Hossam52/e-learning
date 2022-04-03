abstract class ProfileStates {}

class IntialProfileState extends ProfileStates {}

//Get profile
class ProfileLoadingState extends ProfileStates {}

class ProfileSuccessState extends ProfileStates {}

class ProfileErrorState extends ProfileStates {}

//Get posts

class ProfilePostsLoadingState extends ProfileStates {}

class ProfilePostsSuccessState extends ProfileStates {}

class ProfilePostsErrorState extends ProfileStates {}

class ProfileMorePostsLoadingState extends ProfileStates {}

class ProfileMorePostsSuccessState extends ProfileStates {}

class ProfileMorePostsErrorState extends ProfileStates {}

//Get followers
class ProfileFollowersLoadingState extends ProfileStates {}

class ProfileFollowersSuccessState extends ProfileStates {}

class ProfileFollowersErrorState extends ProfileStates {}
