//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VideoShare {
    struct Video {
        address owner;
        string title;
        string description;
        string videoHash;
        string url;
        uint256 timestamp;
        mapping(uint256 => Comment) comments;
        uint256 commentCount;
    }

    struct Comment {
        address commenter;
        string text;
        uint256 timestamp;
    }

    mapping(uint256 => Video) public videos;
    uint256 public videoCount = 0;

    event VideoUploaded(uint256 videoId, string title, string description, string videoHash, uint256 timestamp);
    event CommentAdded(uint256 videoId, uint256 commentId, string text, uint256 timestamp);

    function uploadVideo(string memory _title, string memory _description ,string memory _url ,string memory _videoHash) public {
        videoCount++;
        Video storage newVideo = videos[videoCount];
        newVideo.owner = msg.sender;
        newVideo.title = _title;
        newVideo.description = _description;
        newVideo.timestamp = block.timestamp;
        newVideo.url = _url;
        newVideo.commentCount = 0;
        emit VideoUploaded(videoCount, _title, _description, _videoHash, block.timestamp);
    }

    function addComment(uint256 _videoId, string memory _text) public {
        require(_videoId <= videoCount && _videoId > 0, "Invalid video ID");
        Video storage video = videos[_videoId];
        video.commentCount++;
        video.comments[video.commentCount] = Comment(msg.sender, _text, block.timestamp);
        emit CommentAdded(_videoId, video.commentCount, _text, block.timestamp);
    }

    function getVideo(uint256 _videoId) public view returns (string memory, string memory, string memory,string memory, uint256, uint256) {
        require(_videoId <= videoCount && _videoId > 0, "Invalid video ID");
        Video storage video = videos[_videoId];
        return (video.title, video.description, video.videoHash,video.url, video.timestamp, video.commentCount);
    }
   

    function getComment(uint256 _videoId, uint256 _commentId) public view returns (string memory, address, uint256) {
        require(_videoId <= videoCount && _videoId > 0, "Invalid video ID");
        require(_commentId <= videos[_videoId].commentCount && _commentId > 0, "Invalid comment ID");
        Comment storage comment = videos[_videoId].comments[_commentId];
        return (comment.text, comment.commenter, comment.timestamp);
    }

    function getVideoCount() public view returns (uint256) {
        return videoCount;
    }

    function getCommentCount(uint256 _videoId) public view returns (uint256) {
        require(_videoId <= videoCount && _videoId > 0, "Invalid video ID");
        return videos[_videoId].commentCount;
    }
}
