module Errors
  class ApiError < StandardError
    def initialize(code, message, custom_message = nil, backtrace = nil)
      
      @code = code
      @message = message
      @custom_message = custom_message
      @backtrace = backtrace
      
      super("#{code}:#{message}")
    end
    
    def to_hash
      {
        :type => self.class.name,
        :code => @code,
        :message => [@message, @backtrace, @custom_message]
      }
    end
  end

  class BusyError < ApiError; end

  # errors that should be ignored
  class CasualError < StandardError; end
  # errors caused by bad user input
  class HumanError < CasualError; end
  class AuthorizationError < CasualError; end

  class UpdateBrowserCacheError < StandardError; end

  # General errors
  G0_INVALID_ERROR_CODE = ['G0', "Invalid error code: %s"]
  G1_UNKNOWN_ERROR = ['G1', "Unknown error: %s"]
  G2_NO_DATA = ['G2', 'FastDB No Data Found']
  
  # Matching related errors
  M0_NO_EXACT_LFL = ['M0', "Only one EXACT or LFL match is permitted per competitor. Please review your matches."]  
  M1_NO_EXACT_EXACT = ['M1', "Only one EXACT match is permitted per competitor. Please review your matches."]
  M2_EXACT_DUPLICATE = ['M2', "Duplicate EXACT match."]
  M3_EXACT_ONLY = ['M3', "Only EXACT match is permitted. Please review your matches."]
  M4_NO_LFL_LFL = ['M4', "Only one LFL match is permitted per competitor. Please review your matches."]
  M5_LFL_ONLY = ['M5', "Only LFL match is permitted. Please review your matches."]
  M6_PRODUCT_KEY_UNALLOWABLE = ['M6', "Unallowable product key matched {0}"]
  M7_BUSY = ['M7', "System busy. Wait..."]
  M8_TOO_BIG_LONG = ['M8', "Too match time/Too big data"]
  M9_ACCOUNT_INDEXING = ['M9', "Account is in process of indexing. Please wait 10 minutes while it is completed"]
  M10_NO_EXACT_1LFL = ['M0', "Only one EXACT or one LFL match is permitted per competitor. Please review your matches."]

  P0_URL_NOT_WITHIN_OWN_DOMAINS = ['P0', "URL doesn't belong to any domain registered as customer owned"]
  P1_URL_NOT_WITHIN_CMP_DOMAINS = ['P1', "URL doesn't belong to any domain registered as customer competitor"]
  
  # Search scripts
  S0_INVALID_SEARCH_SCRIPT = ['S0', 'Invalid search script']
  S1_NO_SEARCH_SCRIPT = ['S1', 'No search script']
  S2_SEARCH_SCRIPT_FAILED = ['S2', 'Search script failed']
  S3_SEARCH_SCRIPT_TIMEOUT = ['S3', 'Search script timeout']
  
  
  U0_EMAIL_NOT_SET = ['U0', "E-Mail address is not set for the user"]
  
  D0_MULTIPLE_DOMAINS_FOUND = ['D0', "Multiple domains found, please select one"]

  CODES = [
    G0_INVALID_ERROR_CODE,
    G1_UNKNOWN_ERROR,
    G2_NO_DATA,
    
    M0_NO_EXACT_LFL,
    M1_NO_EXACT_EXACT,
    M2_EXACT_DUPLICATE,
    M3_EXACT_ONLY,
    M4_NO_LFL_LFL,
    M5_LFL_ONLY,
    M6_PRODUCT_KEY_UNALLOWABLE,
    M7_BUSY,
    M8_TOO_BIG_LONG,

    P0_URL_NOT_WITHIN_OWN_DOMAINS,
    P1_URL_NOT_WITHIN_CMP_DOMAINS,
    
    S0_INVALID_SEARCH_SCRIPT,
    S1_NO_SEARCH_SCRIPT,
    S2_SEARCH_SCRIPT_FAILED,
    S3_SEARCH_SCRIPT_TIMEOUT,
    
    U0_EMAIL_NOT_SET,
    
    D0_MULTIPLE_DOMAINS_FOUND,
  ]

  def self.get_exception(code, custom_message = nil, msg = nil)
    if code == M7_BUSY
      BusyError.new(code.first, code.last.gsub('{0}', msg || ''), custom_message)
    elsif CODES.include?(code)
      ApiError.new(code.first, code.last.gsub('{0}', msg || ''), custom_message)
    else
      ApiError.new(
        G0_INVALID_ERROR_CODE.first,
        sprintf(G0_INVALID_ERROR_CODE.last, code.to_s),
        custom_message,
      )
    end
  end

  def self.raise(code, custom_message = nil, msg = nil)
    puts "Error: #{custom_message}"
    Kernel::raise(get_exception(code, custom_message, msg))
  end
  
  def self.to_api_error(e)
    ApiError.new(
      G1_UNKNOWN_ERROR.first, 
      sprintf(G1_UNKNOWN_ERROR.last, e.to_s), nil,
      (e.backtrace||[]).join("\n"))
  end
end
