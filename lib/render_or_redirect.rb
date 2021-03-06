module RenderOrRedirect
  def render_or_redirect response, options={}
    options[:status] ||= :ok
    respond_to do |format|
      format.html { 
        if options[:redirect_url]
          redirect_options = response ? {:error => response[:error], :notice => response[:notice]} : {}
          redirect_to options[:redirect_url], redirect_options
        else
          @data = response
          render options
        end
      }
      format.json {
        render options.merge({:json => {:data => response.as_json, :extra => options}})
      }
    end
  end  
  
  def pretty_errors errors
    perrors = {}
    errors.each do |key, value|
      perrors[key] = "#{key.to_s.capitalize} #{value}"
    end
    perrors
  end
end

class ActionController::Base
  include RenderOrRedirect
end