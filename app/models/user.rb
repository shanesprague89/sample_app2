class User < ActiveRecord::Base
    has_secure_password #one powerful function!
    before_save { email.downcase! } #lowercases before saving to database.
                                    #Not all databases are case sensitive.
    
    before_create :create_remember_token
    
    def User.new_remember_token
        SecureRandom.urlsafe_base64
    end
    
    def User.digest(token)
        Digest::SHA1.hexdigest(token.to_s)
    end
    
    validates :name,    presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email,   presence: true, format: { with: VALID_EMAIL_REGEX },
                        uniqueness: { case_sensitive: false }
                        
    validates :password, length: { minimum: 6 }
    
    private
    
        def create_remember_token
            self.remember_token = User.digest(User.new_remember_token)
        end
end
