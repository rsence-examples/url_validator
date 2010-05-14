#--
##   Copyright 2010 Riassence Inc.
 #   http://riassence.com/
 #
 #   You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
 #   along with this software package. If not, contact licensing@riassence.com
 ##
 #++
 
# = URL Validator
# This plugin demonstrates real time URL validation of URLs given by client.
# 

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
  

  def domain_valid?( msg, url_string )
    puts "checking domain validity... #{url_string.data}"
    set_error( msg, "")
    begin
      domain = URI.parse(url_string.data).host
    rescue StandardError => err
      set_state( msg, false )
      set_error( msg, err)
      return true
    end
    puts "URI formed: #{domain.inspect}"
    if domain == nil
      set_state( msg, false )
      return true
    end
    set_state( msg, @dns.getresources(domain, Resolv::DNS::Resource::IN::A).size > 0 )
  return true
  end
  
  def set_state( msg, state )
    ses = get_ses( msg )
    ses[:valid_state].set( msg, state )
  end
  
  def set_error( msg, message )
    ses = get_ses( msg )
    ses[:error_message].set( msg, message)
  end
  
end