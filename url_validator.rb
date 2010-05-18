##   
 #   Copyright 2010 Riassence Inc.
 #   http://riassence.com/
 #
 #   You should have received a copy of the GNU Lesser General Public License
 #   along with this software package. If not, contact licensing@riassence.com
 ##
 
# = URL Validator
# This plugin demonstrates real time validation of URLs given by the client.
#
# Please refer to rdoc of rsence gem for full server side documentation.
# 
# Feel free to join #rsence on the IRCnet and FreeNode networks for further 
# questions.

class URLValidator < GUIPlugin
require 'resolv'
require 'uri'
require 'net/http'
  
  def open
    super
    begin
      @dns = Resolv::DNS.new
    rescue
      puts "#{e.inspect}"
    end
  end
  
  def close
    super
    @dns.close
  end
  
  def domain_valid?( msg, url_string )
    puts "checking domain validity... #{url_string.data}" # 
    set_error( msg, "")
    begin
      domain = URI.parse(url_string.data).host
    rescue StandardError => err
      set_state( msg, false )
      set_error( msg, err)
      return true
    end
    if domain == nil
      set_state( msg, false )
      return true
    end
    set_state( msg, @dns.getresources(domain, Resolv::DNS::Resource::IN::A).size > 0 )
  return true
  end
  
  # A helper function to set validator state.
  # Msg has the session information and validator state is either 
  # +true+ or +false+.
  def set_state( msg, state )
    ses = get_ses( msg )
    ses[:valid_state].set( msg, state )
  end
  
  # A helper function to set error message.
  def set_error( msg, message )
    ses = get_ses( msg )
    ses[:error_message].set( msg, message)
  end
  
end