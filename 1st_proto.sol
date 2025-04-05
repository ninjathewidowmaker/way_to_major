//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract SocialDapp {

    
    event BlockCreated(
        uint32 postID,
        bytes10 userID,
        address author,
        uint64 timestamp,
        string content,
        uint32 approves,
        uint32 disapproves,
        string comment
    ); // Event for creating a post

    event BlockApproved(
        uint32 postID,
        address author,
        uint64 timestamp,
        uint32 newapproves
    ); // Event for liking a post    

    event BlockDisApproved(
        uint32 postID,
        address author,
        uint64 timestamp,
        uint32 newdisapproves
    ); // Event for unliking a post

    event BlockCommented(
        uint32 postID,
        bytes10 userID,
        address author,
        uint64 timestamp,
        string comment
    ); // Event for creating a comment

    struct newBlock {
        uint32 postID;
        address author;
        bytes10 userID;
        string content;
        uint64 timestamp;
        uint32 approves;
        uint32 disapproves;
    }

    struct NewComment {
        uint32 postID;
        address author;
        bytes10 userID;
        uint timestamp;
        string comment;
    }

    struct NewApprove {
        uint32 postID;
        address author;
        uint timestamp;
        uint32 newapproves;
    }

    struct NewDisApprove {
        uint32 postID;
        address author;
        uint timestamp;
        uint32 newdisapproves;
    }

    uint32 public postID = 0;

    mapping(uint32 => newBlock) public blocks;
    mapping(uint32 => NewComment[]) public comments;

    function NewBlockCreation(string memory _block, bytes10 _userID) public returns(uint32) {
        postID++;
        newBlock memory newPost = newBlock({
            postID: postID,
            author: msg.sender,
            userID: _userID,  // Now passing userID as a parameter
            content: _block,
            timestamp: uint64(block.timestamp),
            approves: 0,
            disapproves: 0
        });
        
        blocks[postID] = newPost;  // Store the post
        emit BlockCreated(postID, _userID, msg.sender, uint64(block.timestamp), _block, 0, 0, "");  // Emit BlockCreated event
        return postID;
    }

    function NewCommentCreation(uint32 _postID, string memory _comment, bytes10 _userID) public {
        NewComment memory newComment = NewComment({
            postID: _postID,
            author: msg.sender,
            userID: _userID, 
            timestamp: block.timestamp,
            comment: _comment     
        });

        comments[_postID].push(newComment);  // Add comment to the post's comments array
        emit BlockCommented(_postID, _userID, msg.sender, uint64(block.timestamp), _comment);  // Emit BlockCommented event
    }

    function NewApprovesCreation(uint32 _postID) external {
        require(msg.sender != blocks[_postID].author, "You can't approve your own post"); // Prevent self-approves
        blocks[_postID].approves++; // Increment approve count
        emit BlockApproved(_postID, blocks[_postID].author, uint64(block.timestamp), blocks[_postID].approves); // Emit BlockApproved event
    }

    function NewDisApprovesCreation(uint32 _postID) external {
        require(msg.sender != blocks[_postID].author, "You can't disapprove your own post"); // Prevent self-disapproves
        blocks[_postID].disapproves++; // Increment disapprove count
        emit BlockDisApproved(_postID, blocks[_postID].author, uint64(block.timestamp), blocks[_postID].disapproves); // Emit BlockDisApproved event
    }

}
