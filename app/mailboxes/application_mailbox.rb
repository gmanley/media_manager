class ApplicationMailbox < ActionMailbox::Base
  routing /welcome@mega.nz/i => :mega
  routing /graymanfm/i => :mega
end
