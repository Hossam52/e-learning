abstract class VideosStates {}

class AppInitialState extends VideosStates {}

/// Teacher Add Videos States
class TeacherVideoChangeState extends VideosStates {}

/// Teacher add playlist
class PlaylistAddLoadingState extends VideosStates {}

class PlaylistAddSuccessState extends VideosStates {}

class PlaylistAddErrorState extends VideosStates {}

/// Teacher get subject playlists
class SubjectPlaylistsLoadingState extends VideosStates {}

class SubjectPlaylistsSuccessState extends VideosStates {}

class SubjectPlaylistsErrorState extends VideosStates {}

/// Teacher delete playlist with id
class PlaylistDeleteLoadingState extends VideosStates {}

class PlaylistDeleteSuccessState extends VideosStates {}

class PlaylistDeleteErrorState extends VideosStates {}

// Add teacher video states
class GroupAddVideoLoadingState extends VideosStates {}

class GroupAddVideoSuccessState extends VideosStates {}

class GroupAddVideoErrorState extends VideosStates {}


