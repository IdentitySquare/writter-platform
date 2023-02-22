class RecommendationService
    def initialize(user)
        @user = user
      end
    
    def recommended_accounts(sample)
        # Get the first sample number of users that the user is not following and is not the user
        User.where.not(id: @user.following_ids).where.not(id: @user.id).limit(sample)
    end

    def recommended_posts(sample)
        # Get the a random sample number of posts written by accounts that the user is following or is writter by recommended_accounts
        Post.published.where(user_id: @user.following_ids).or(Post.where(user_id: recommended_accounts(10).ids)).sample(sample)
    end
end