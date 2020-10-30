require 'rubygems'
require 'nokogiri'
require 'htmlentities'
#require 'iconv'

require './src/errors'

class RuleTools

  RULE_PART_ALLOW = 'allow'
  RULE_PART_UNAVAILABLE = 'unavail'
  RULE_PART_NAME = 'name'
  RULE_PART_PRICE = 'price'

  RULE_PART_PROMO_ID = 'promoid'
  RULE_PART_PROMO_NAME = 'promoname'
  RULE_PART_PROMO_EXPIRE = 'promoexpire'
  RULE_PART_PROMO_TYPE = 'promotype'
  RULE_PART_PROMO_SUBTYPE = 'promosubtype'
  RULE_PART_PROMO_MB_PRICE = 'promombprice'

  RULE_PART_PROMO2_ID = 'promoid2'
  RULE_PART_PROMO2_NAME = 'promoname2'
  RULE_PART_PROMO2_EXPIRE = 'promoexpire2'
  RULE_PART_PROMO2_TYPE = 'promotype2'
  RULE_PART_PROMO2_SUBTYPE = 'promosubtype2'
  RULE_PART_PROMO2_MB_PRICE = 'promombprice2'

  RULE_PART_PROMOS_OTHER = 'promosother'
  RULE_PART_PROMOS_OTHER2 = 'promosother2'
  RULE_PART_PROMOS_OTHER3 = 'promosother3'
  RULE_PART_PROMOS_OTHER4 = 'promosother4'
  RULE_PART_PROMOS_OTHER5 = 'promosother5'
  RULE_PART_PROMOS_OTHER6 = 'promosother6'
  RULE_PART_PROMOS_OTHER7 = 'promosother7'
  RULE_PART_PROMOS_OTHER8 = 'promosother8'
  RULE_PART_PROMOS_OTHER9 = 'promosother9'

  RULE_PART_PROMO_LIMIT = 'promolimit'
  RULE_PART_UNIT = 'unit'
  RULE_PART_SECOND_PRICE = 'secondprice'
  RULE_PART_REGULAR_PRICE = 'regularprice'
  RULE_PART_DELIVERY_PRICE = 'deliveryprice'
  RULE_PART_SECOND_UNIT = 'secondunit'
  RULE_PART_HIDDEN_EAN = 'hidden_ean'
  RULE_PART_MATCH_EAN = 'match_ean'
  RULE_PART_EAN = 'ean'
  RULE_PART_EAN2 = 'ean2'
  RULE_PART_EAN3 = 'ean3'
  RULE_PART_EAN4 = 'ean4'
  RULE_PART_EAN5 = 'ean5'
  RULE_PART_EAN6 = 'ean6'
  RULE_PART_EAN7 = 'ean7'
  RULE_PART_EAN8 = 'ean8'
  RULE_PART_EAN9 = 'ean9'
  LAST_FIXED_EAN = 9
  RULE_PART_EAN_LIST = 'ean_list'
  RULE_PART_SKU = 'sku'
  RULE_PART_SKU2 = 'sku2'
  RULE_PART_SKU3 = 'sku3'
  RULE_PART_SKU4 = 'sku4'
  RULE_PART_SKU5 = 'sku5'
  RULE_PART_SKU6 = 'sku6'
  RULE_PART_SKU7 = 'sku7'
  RULE_PART_MODEL = 'model'
  RULE_PART_STOCK = 'stock'
  RULE_PART_INSTORE_STOCK = 'stock2'
  RULE_PART_BOPIS = 'stock2'
  RULE_PART_IMAGE = 'image'
  RULE_PART_IMAGE_RESET = 'image_reset'
  RULE_PART_PRIVATE_LABEL = 'privatelabel'
  RULE_PART_BREADCRUMB = 'breadcrumb'
  RULE_PART_BREADCRUMB_URL = 'breadcrumb_url'
  RULE_PART_BRAND = 'brand'
  RULE_PART_SELLER = 'seller'
  RULE_PART_UPC = 'upc'
  RULE_PART_UPC2 = 'upc2'
  RULE_PART_UPC3 = 'upc3'
  RULE_PART_UPC4 = 'upc4'
  RULE_PART_TAG = 'tag'
  RULE_PART_TAG2 = 'tag2'
  RULE_PART_TAG3 = 'tag3'
  RULE_PART_TAG4 = 'tag4'
  RULE_PART_DIFF = 'diff'
  RULE_PART_CUSTOMER_IMAGES = 'customer_images'
  RULE_PART_FLAGS = 'flags'
  #RULE_PART_PRODUCT_CODE = 'prodcode'
  #RULE_PART_PRODUCT_OTHER_CODES = 'othercodes'
  RULE_PART_DELISTED = 'delisted'
  RULE_PART_FORCE_DELISTED = 'force_delisted'

  PROMO_PARSED = :promo_parsed
  PROMO2_PARSED = :promo2_parsed

  #RULE_PART_FLAGS = 'flags'

  RULE_PART_RRQ_TITLE = 'title'
  RULE_PART_RRQ_CONTENT = 'content'
  RULE_PART_RRQ_AUTHOR = 'author'
  RULE_PART_REVIEW_URL = 'review_url'
  RULE_PART_REVIEW_ID = 'review_id'
  RULE_PART_RRQ_RATINGS_COUNT = 'ratings_count'
  RULE_PART_RRQ_RATING_SCALE = 'rating_scale'
  RULE_PART_RRQ_RATING = 'rating'

  @@PF_IN_STOCK = '*Profitero in stock*'
  @@PF_OUT_OF_STOCK = '*Profitero out of stock*'

  PRODUCT_KEY = :key
  BRANDED = '<BRANDED>'
  BREADCRUMBS_SEPARATOR = "***"

  @@html_coder = HTMLEntities.new

  #Keys supported as value in product loader
  def self.value_key?(key)
    ['timestamp', RULE_PART_STOCK, RULE_PART_INSTORE_STOCK, RULE_PART_PRICE,
              RULE_PART_UNIT, RULE_PART_SECOND_PRICE,
              RULE_PART_PROMO_EXPIRE, RULE_PART_PROMO_ID, RULE_PART_PROMO_NAME, RULE_PART_PROMO2_EXPIRE, RULE_PART_PROMO2_ID, RULE_PART_PROMO2_NAME, RULE_PART_PROMO_LIMIT,
     RULE_PART_PROMO_TYPE, RULE_PART_PROMO_SUBTYPE, RULE_PART_PROMO_MB_PRICE,
     RULE_PART_PROMO2_TYPE, RULE_PART_PROMO2_SUBTYPE, RULE_PART_PROMO2_MB_PRICE,
              RULE_PART_REGULAR_PRICE, RULE_PART_DELIVERY_PRICE,
              RULE_PART_SECOND_UNIT, RULE_PART_DELISTED,RULE_PART_FORCE_DELISTED,

     RULE_PART_PROMOS_OTHER,
     RULE_PART_PROMOS_OTHER2,
     RULE_PART_PROMOS_OTHER3,
     RULE_PART_PROMOS_OTHER4,
     RULE_PART_PROMOS_OTHER5,
     RULE_PART_PROMOS_OTHER6,
     RULE_PART_PROMOS_OTHER7,
     RULE_PART_PROMOS_OTHER8,
     RULE_PART_PROMOS_OTHER9,

             RULE_PART_RRQ_TITLE,
             RULE_PART_RRQ_CONTENT,
             RULE_PART_RRQ_AUTHOR,
             RULE_PART_REVIEW_URL,
             RULE_PART_REVIEW_ID,
             RULE_PART_RRQ_RATINGS_COUNT,
             RULE_PART_RRQ_RATING_SCALE,
             RULE_PART_RRQ_RATING
    ].include?(key)
  end

  def self.multi_part?(key)
    [RuleTools::RULE_PART_IMAGE, RuleTools::RULE_PART_TAG, RuleTools::RULE_PART_SKU, RuleTools::RULE_PART_EAN, RuleTools::RULE_PART_UPC, RuleTools::RULE_PART_PROMOS_OTHER].include?(key.to_s)
  end

  #All supported Keys  in prodict loader
  def self.ignore_key(key)
    [PROMO_PARSED, PROMO2_PARSED].include?(key.to_sym)
  end

  def self.validate_key(key)
    return true if key.to_s.end_with?('?') #skip if present

    raise Errors::HumanError, "Unsupported product property key found: [#{key}]" unless \
    [
      #RULE_PART_ALLOW,
      #RULE_PART_UNAVAILABLE,
      RULE_PART_NAME,
      RULE_PART_PRICE,
      RULE_PART_PROMO_EXPIRE,
      RULE_PART_PROMO_NAME,
      RULE_PART_PROMO_ID,
      RULE_PART_PROMO2_EXPIRE,
      RULE_PART_PROMO2_NAME,
      RULE_PART_PROMO2_ID,
      RULE_PART_PROMOS_OTHER,
      RULE_PART_PROMOS_OTHER2,
      RULE_PART_PROMOS_OTHER3,
      RULE_PART_PROMOS_OTHER4,
      RULE_PART_PROMOS_OTHER5,
      RULE_PART_PROMOS_OTHER6,
      RULE_PART_PROMOS_OTHER7,
      RULE_PART_PROMOS_OTHER8,
      RULE_PART_PROMOS_OTHER9,
      RULE_PART_PROMO_LIMIT,
      RULE_PART_UNIT,
      RULE_PART_SECOND_PRICE,
      RULE_PART_REGULAR_PRICE,
      RULE_PART_DELIVERY_PRICE,
      RULE_PART_SECOND_UNIT,
      RULE_PART_PRIVATE_LABEL,
      RULE_PART_STOCK,
      RULE_PART_INSTORE_STOCK,
      RULE_PART_IMAGE,
      RULE_PART_IMAGE_RESET,
      #RULE_PART_DESCRIPTION,
      RULE_PART_BREADCRUMB,
      RULE_PART_BREADCRUMB_URL,
      #RULE_PART_OTHER_DESCRIPTION,
      #RULE_PART_PRODUCT_CODE,
      #RULE_PART_PRODUCT_OTHER_CODES,
      RULE_PART_BRAND,
      RULE_PART_SELLER,
      RULE_PART_DELISTED,
      RULE_PART_EAN,
      RULE_PART_EAN2,
      RULE_PART_EAN3,
      RULE_PART_EAN4,
      RULE_PART_EAN5,
      RULE_PART_EAN6,
      RULE_PART_EAN7,
      RULE_PART_EAN8,
      RULE_PART_EAN9,
      RULE_PART_EAN_LIST,
      RULE_PART_UPC,
      RULE_PART_UPC2,
      RULE_PART_UPC3,
      RULE_PART_UPC4,
      RULE_PART_MODEL,
      RULE_PART_SKU,
      RULE_PART_SKU2,
      RULE_PART_SKU3,
      RULE_PART_SKU4,
      RULE_PART_TAG,
      RULE_PART_TAG2,
      RULE_PART_TAG3,
      RULE_PART_TAG4,
      RULE_PART_DIFF,
      RULE_PART_CUSTOMER_IMAGES,
      RULE_PART_FLAGS,
      PRODUCT_KEY.to_s,
      RULE_PART_PROMO_TYPE, RULE_PART_PROMO_SUBTYPE, RULE_PART_PROMO_MB_PRICE, RULE_PART_PROMO2_TYPE, RULE_PART_PROMO2_SUBTYPE, RULE_PART_PROMO2_MB_PRICE,
      'rule',
      'url',
      'force_timestamp'
    ].include?(key.to_s)

    true
  end

  def self.rule_priority (delisted, stock, parts_count, priority)
    (delisted ? 1000000 : 0) +
    (stock ? 500000 : 0) +
    (100000 + priority * 50) +
    parts_count
  end

  def self.to_regex(value)

    value = value.to_s
    # Экранируем спецсимволы
    value.gsub!(/([\(\)\[\]\{\}\.\*\?\|\^\$\:\+])/) do
      '\\' + $1
    end

    # Цифры
    value.gsub(/\d+/, '\d+')
  end
=begin
  def self.calc_reg_price(prod)
    promo_name = prod[RULE_PART_PROMO_NAME.to_sym]
    rp_key = RULE_PART_REGULAR_PRICE.to_sym

    if prod[RULE_PART_PRICE.to_sym] && promo_name && !prod[rp_key]
      price = prod[RULE_PART_PRICE.to_sym].to_f

      if promo_name =~ /Was ([\d\.]+)p/i
        prod[rp_key] = ($1.to_f / 100).round(2)
      elsif promo_name =~ /Was \D+(\d+\.\d{2})/i
        prod[rp_key] = ($1.to_f).round(2)
      elsif promo_name =~ /^SAVE \D+(\d+\.\d{2})/i
        prod[rp_key] = (price + $1.to_f).round(2)
      elsif promo_name =~ /^SAVE (\d+)p/i
        prod[rp_key] = (price + $1.to_f / 100).round(2)
      elsif promo_name =~ /^Save (\d+)%/i
        prod[rp_key] = (price + price * $1.to_f / 100).round(2)
      elsif promo_name =~ /^Save (\d+)\/(\d+)/i
        prod[rp_key] = (price + price * $1.to_f / $2.to_f).round(2)
      elsif promo_name =~ /^Half Price/i
        prod[rp_key] = (price * 2).round(2)
      end
    end
  end
=end
  #create cleared document
  def self.doc(orig_body, opt = {}, feedback = {})
    url = opt[:url]
    source = opt[:source]
    opt[:encoding] = opt[:encoding].downcase if opt[:encoding]

    body = "#{orig_body}"

    body.force_encoding("ASCII-8BIT")

    raise "Empty body! #{url || source}" if body.size < 1024 && body.strip.empty? && !opt[:allow_zero]
    body = "<body><span id='pf_marker_zero'>ZERO</span</body>" if body.strip.empty?

    body.gsub!(/\x00|\x01|&#1;|&#xd83c;&#xdf00;|&#5535[6-8];&#5\d\d\d\d;|&#57119;|&#55357;|&#56469;|&#55356;|&#57140;|&#56545;|&#56482;|&#57276;|&#57255;|&#56462;|&#56397;|&#57145;|&#56349;|&#56359;|&#57152;|&#56409;/n, "") #some bullshit fr symbols ASIN B07CVJ8MR6 es B07BRK4VHY de B07CHLKV7Z

    if opt[:parser_script] && opt[:parser_script].respond_to?(:preprocess)
      body = (opt[:parser_script].preprocess((url || source), body)) || body
    end

    # hack! for shop 1162 closing </html> and </body> tags were commented
    #body.gsub!(/<!-- <\/body> -->/, '</body>')
    #body.gsub!(/<!-- <\/html> -->/, '</html>')
    # cut erb tags
    body.gsub!(/<%.*?%>/m, '')

    #perf for next command https://shop.rewe.de/lindt-hochfein-200g/PD9351205
    body.gsub!('<!---->', '')

    # cut incorrect comment <!-- --!>
    #body.gsub!(/<!--.*?\K--!>/, '-->')
    body.gsub!(/<!--(.*?)--!>/, '<!-- \\1 -->') if body.index('--!>')

    last_id = nil

    #prevent found attrs inside script
    body.gsub(/<script.*?\/script>/m, '').scan(/\sid\s*=\s*['"](\w+)['"]/) {|v|
      last_id = v.first
    }

    #body.scan(/\sid=['"]([^"'\/>]+)['"]/) {|v|
    #  last_id = v.first
    #}

    #set tricky markers (internal used for document structure checking and rules)
    pos_html = [body.rindex('</html>'), body.rindex('</HTML>')].compact.max
    pos_body = [body.rindex('</body>'), body.rindex('</BODY>')].compact.max

    pos_tag = [pos_html||-1, pos_body||-1].max
    pos_tag = nil if pos_tag == -1
    pf_opt = ((opt||{})[:profitero]||[]).map {|v| "<span id='pf_#{v.keys.first}'>#{v.values.first}</span>"}.join
    #raise "#{opt}"

    unless body.index('pf_marker')

      html = "
        <span id='pf_marker'>profitero</span><br/>
        #{pf_opt}<br/>
        <span id='pf_marker_in_stock'>In stock</span><br/>
        <span id='pf_marker_out_of_stock'>Out of stock</span>"

      if pos_tag
        body[pos_tag, 0] = html
      else
        body += html
      end
    end

    main_encoding = $1.downcase if /<meta[^>]+charset\s*=\s*[\"']?([^\s\"';>]+)[\"';]?.*?>/im =~ body

    if opt[:debug]
      puts "Document specified encoding: #{main_encoding}"
      puts "Options: #{opt}"
    end

    # fixing some incorrectly specified encoding names
    #main_encoding = 'utf-8' if main_encoding =~ /^utf8$/i

    body.gsub!(/<meta[^>]+charset.*?>/im, '')
    body.gsub!(/@import\s+"(.*?)"/m) {
      "@import \"#{::Tools::URLNormalizer.to_absolute(url, $1)}\""
    } if url

    body.gsub!("& ", "&amp; ")
    body << " -->" #close any unclosed tags bug fix nokigiri

    #p last_id
    #puts body
    #special correct code for encodings
    #if encoding and ['gb2312'].include?(encoding.downcase)
      #test/html/taobao-list.html test/html/taobao-list2.html
      #bad_symbols = [/\xA8\x8B/, /\x99\xEC/, /\xF3\x8A/, /\xF3\x8C/, /\xBF\x73/, /\xA9\x49/]
      #bad_symbols.each { |rg| body = body.gsub(rg, "?") }
    #end

    iso_8859_1 = main_encoding && ['gbk', 'gb2312', 'big5'].include?(main_encoding) ? nil : "ISO-8859-1"

    encodings = [!(main_encoding||'').strip.empty? && opt[:force_encoding] == 'PAGE' ? main_encoding : nil,
                  (opt[:encoding]||'').strip.empty? ? nil : opt[:encoding],
                  main_encoding,
                  (opt[:http_encoding]||'').strip.empty? ? nil : opt[:http_encoding],
                  'UTF-8', iso_8859_1, "ISO-8859-2", main_encoding].compact.map { |s| s.gsub(/^utf8$/i, 'utf-8').gsub(/^iso_\d+\-\d+$/i, 'iso-8859-1').downcase }.uniq

    doc = nil
    parsed_well = true

    #find encoding (sometime encoding incorrect in HTML meta)
    start_time = Time.now.to_i
    loop do
      encoding = encodings.shift

      if feedback
        feedback[:parse_count] ||= 0
        feedback[:parse_count] += 1
        feedback[:parse_enc_chain] ||= []
        feedback[:parse_enc_chain] << encoding
      end
      #puts "Apply #{encoding}"
      body.force_encoding(encoding)
      doc = Nokogiri::HTML.parse(body, nil, encoding)
      doc.root.send(:in_context, '<b/>', Nokogiri::XML::ParseOptions::DEFAULT_XML)
      #"81, Input is not proper UTF-8, indicate encoding !"
      #"9, Input is not proper UTF-8, indicate encoding !\nBytes: 0xA3 0x35 0x39 0x39"
      #"9, Invalid char in CDATA 0x1A" - Ctrl-Z - ignore
      #"9, Invalid char in CDATA 0x10" - data link escape character  - ignore
      #1544, encoder error - found in china page-product2
      #6003 input conversion failed due to input error, bytes 0xAB 0xEF 0xBF 0xBD
      #found = (doc.to_html.size.to_f / body.size > 0.90) #(!last_id || doc.xpath("//*[@id='#{last_id}']").first)
      parsed_well = !pos_tag || doc.xpath("//*[@id='pf_marker' or @id = '#{last_id}']").first
      has_critical_errors = !doc.errors.select() {|err| [1544, 6003, 81].include?(err.code) || err.code == 9 && ![0x1A,0x02,0x08,0x10].include?(err.int1) }.empty?
      #doc.errors.each {|e| p e}
      if opt[:debug]
        puts "***Document errors for encoding #{encoding}***"
        doc.errors.select.group_by { |err|
          err.code
        }.each { |code, err|
          puts "  Error: #{err.first.code} #{err.first.message} Line #{err.first.line} Col #{err.first.column}"
          if err.first.code == 9
            part_s = body.split("\n")[err.first.line-1][[0, err.first.column-25].max..err.first.column+25]
            puts "    Line ...#{part_s}..."
            puts "    Chars/Bytes ...#{part_s.chars.map { |ch| "#{ch}(#{ch.bytes.join(' ')})"}.join(' ')}..."
          end
        }
      end

      if encodings.empty? || parsed_well && !has_critical_errors || (['Y', true].include?(opt[:force_encoding]) && encoding == opt[:encoding]) || (opt[:force_encoding] == 'PAGE' && encoding == main_encoding)
        break
      end

      #write critical errors
          # 0D │ 0A 0B 0D 0A
      #break if parsed_well && doc.errors.select() {|err| [1544, 6003, 81, 9].include?(err.code)}.empty? || encodings.empty?

      raise "Timeout to parse file: to many errors in #{url}" if (Time.now.to_i - start_time) > 30
    end
    #puts doc.to_html

    #kill incorrect symbols in origanal encoding
    while pos_tag && !parsed_well
      corrected = false
      doc.errors.each { |err|
        if err.code == 6003
          bad_seq = ""
          bad_seq.force_encoding('BINARY')
          err.str1.scan(/0x(..)/) {|v| bad_seq << v[0].to_i(16) if bad_seq.size < 2 }
          bad_seq.force_encoding('BINARY')
          enc = body.encoding
          body = body.force_encoding('BINARY').gsub(bad_seq, "?")
          body.force_encoding(enc)
          corrected = true
          #p '-------'
          #bad_seq.each_byte{|b| print b.to_s(16)}
          break
        end
      }
      break unless corrected
      doc = Nokogiri::HTML.parse(body, nil, main_encoding) #, Nokogiri::XML::ParseOptions::HUGE)
      doc.root.send(:in_context, '<b/>', Nokogiri::XML::ParseOptions::DEFAULT_XML)
      parsed_well = doc.xpath("//*[@id='pf_marker' or @id = '#{last_id}']").first
      break if parsed_well && doc.errors.select() {|err| [1544, 6003, 81].include?(err.code) || err.code == 9 && ![0x1A,0x02].include?(err.int1)}.empty?
    end

    unless parsed_well
      lpos = doc.to_s.index("'#{last_id}'") || doc.to_s.index('"' + last_id + '"')
      puts con_clr(doc.to_s[lpos-500, 1000], 'blue') if lpos
      raise "Document corrupted. last_id #{last_id} #{!!parsed_well} #{lpos} src #{source || url} (#{main_encoding}) #{body.size}bytes [#{body[0,250].gsub(/\n/, '~')}...]"
    end

    #force encoding
    unless doc.encoding
      raise "Unsupported document #{source || url}. Content length #{orig_body.size} [#{body[0,250].gsub(/\n/, '~')}...]" unless doc.root()
      doc.encoding = doc.root().text().to_s.encoding.to_s
    end

    encoding ||= doc.encoding()
    html = doc.xpath('//html').first
    if encoding && html #Nokogiri always add <html> tag
      child = html.children.first
      if child
        child.add_previous_sibling(Nokogiri::XML::Comment.new(doc,
            %{<meta http-equiv="Content-Type" content="text/html; charset=#{encoding}">}
          )
        )
      end
    end

    doc
  end

  def self.find_uniq_xpath(document, context, marking_xpath, path = [], path_mand = false)
    ctx_node = context ? document.xpath(context[:xpath]).first : document
    raise "Context node #{context[:xpath]} must be NODE but not #{ctx_node}" if context && !ctx_node.is_a?(Nokogiri::XML::Element)
    nodes = ctx_node.xpath(marking_xpath)
    node = nodes.first rescue nil
    # node может быть равен nil, если
    # 1: на сервер специально прислали херню
    # 2: выделили в браузере ноду, которая была достроена javascript'ом

    if node
      #el = node.is_a?(Nokogiri::XML::Attr) ? node.parent : node
      #if user_id_if_possible and el['id'] and !(/^pf\d+$/ =~ el['id'])
      #  return marking_xpath;
      #end
      return find_uniq_xpath2(document, ctx_node, node, path, path_mand)
    end

    nil
  end

  def self.find_uniq_xpath2(document, ctx_node, node, path = [], path_mand = false)

    found = false
    xpath = []
    path_mand = false if !path or path.empty?

    # Строим путь...
    while node && !node.is_a?(Nokogiri::HTML::Document) do

      cond = ""
      if node == ctx_node
        break
      elsif(node.is_a?(Nokogiri::XML::Attr))
        xpath.unshift("@#{node.name}")
      else
        #search attributes
        path.each { |el|
          next unless el[:id] == node['id']
          cond += ' and ' unless cond.empty?
          cond += "@#{el[:attr]}='#{el[:val]}'"
        } if path

        if cond.empty? #calc index in DOM
          unless found #append only if unique not reached
            index = 1
            prev = node
            while prev = prev.previous do
              if prev.name == node.name && prev.is_a?(Nokogiri::XML::Element)
                index += 1
              end
            end
            xpath.unshift("#{node.name}[#{index}]")
          end
        else
          xpath.unshift("#{node.name}[#{cond}]")
          xpath.unshift("") #means any level
        end
      end

      p = "#{cond.empty? ? '//' : '/'}#{xpath.join('/')}"
      validate = document.xpath(p)

      raise "Incorrect nodes sequence in expression #{p}" if validate.size == 0

      if xpath.size > 2 and !found or !cond.empty?
        if validate.size == 1 #need / to scan any deel
          found = true
          return p unless path_mand #loop up to root to use all path according path_mand parameter
        end
      end

      node = node.parent
      #break if node == ctx_node
    end

    "#{(ctx_node && node == ctx_node) ? './' : (cond.empty? && !found) ? '//' : '/'}#{xpath.join('/')}"
  end

=begin
  def self.find_uniq_xpath_ex(doc, marking_xpath, path, frame, multi = false)

    context = doc.xpath(frame ? frame[:xpath] : '//body').first

    marking_xpath = ".#{marking_xpath}" if marking_xpath =~ /^\//
    node = context.xpath(marking_xpath).first
    if node

      # building xpath from explicitly selected nodes first
      prev = nil
      current = node
      xpath_axes = []
      xpath_nodes = 0
      while current && current != context

        axis = nil
        if current.is_a?(Nokogiri::XML::Attr)
          axis = "@#{node.name}"
        elsif current.is_a?(Nokogiri::XML::Text)
          axis = "text()"
        else
          axis = current.name
          cond = path[current['id']]
          cond_str = nil
          if cond
            cond.delete(:include_node)
            unless cond.empty?
              cond_str = cond.map {|attr, val|
                "#{attr}='#{val}'"
              }.join(' and ')
            end
          end

          index = 1
          sibling = current
          while sibling = sibling.previous do
            if sibling.name == current.name && sibling.is_a?(Nokogiri::XML::Element)
              index +=1
            end
          end

          # - parent of leaf node if leaf node is attribute or text
          # - leaf node
          # - explicity selected nodes
          axis += "[#{cond_str || index}]"
          unless prev.is_a?(Nokogiri::XML::Attr) ||
            prev.is_a?(Nokogiri::XML::Text) ||
            current == node ||
            cond

            axis = nil
          else
            xpath_nodes += 1
          end
        end

        if axis
          xpath_axes.unshift([current, axis])
        end

        prev = current
        current = current.parent
      end

      # adding additional nodes if there is no enough explicitly selected
      # nodes to build uniq xpath
      prev = nil
      current = node
      position = xpath_nodes
      while current && current != context

        xpath = ''
        xpath_axes.each_with_index {|axis, i|
          xpath += axis.last
          if i + 1 < xpath_axes.size
            if xpath_axes[i + 1].first.parent == axis.first
              xpath += "/"
            else
              xpath += "//"
            end
          end
        }

        unless xpath.empty?
          xpath = ".//" + xpath
          # Deleting text() part to correctly validate
          # uniqueness of xpath
          mpath = xpath.gsub(/\/+text\(\)/, '')

          result = context.xpath(mpath)
          if result.empty?
            raise "Incorrect nodes sequence in expression #{xpath}"
          else
            if result.size == 1 && (!path.empty? || xpath_axes.size > 2)
              return xpath
            end
          end
        end

        if current.is_a?(Nokogiri::XML::Element)
          point = xpath_axes[position - 1]
          if point.first == current
            position -= 1
          else

            index = 1
            sibling = current
            while sibling = sibling.previous do
              if sibling.name == current.name && sibling.is_a?(Nokogiri::XML::Element)
                index +=1
              end
            end

            axis = "#{current.name}[#{index}]"
            xpath_axes.insert(position, [current, axis])
          end
        end
        current = current.parent
      end

      nil
    else

      nil
    end

  end
=end

  #returns pair of strings: xpath, regex
  def self.create_rule(document, context, xpath, use_incoming_xpath, sel_text, use_incoming_regexp, keep_text = false, path = [], path_mand = false, name = "")

    xpath = "#{xpath}".force_encoding("ASCII-8BIT")
    sel_text = sel_text.force_encoding("ASCII-8BIT") if sel_text

    # ХPath, который приходит от браузера в идеале должен выглядеть как
    # //[@id='pXXX'].
    #
    # На самом деле он может прийти в таком виде //[@id='pXXX']/TAG[M].../TAG[K]
    # Такая ситуация возможна, если некоторые ноды были достроены javascript'ом
    # и при этом не имеют ID. Но мы стараемся порезать весь javascript, т.к. с
    # этим связана безопасность поэтому подобную ситуацию не рассматриваем.

    # найдем некоторый минимальный путь xpath, который однозначно
    # идентифицирует ноду
    xpath = RuleTools.find_uniq_xpath(document, context, xpath, path, path_mand) unless use_incoming_xpath
    if xpath
      return [xpath, nil] unless sel_text
      if use_incoming_regexp
        if sel_text
          #validate parts
          sel_text.split("\n").each { |regexp|
            extract(document, xpath, regexp, name, name == 'context' || context ? {:all => true} : nil)
          }
        end
        return [xpath, sel_text]
      end

      #puts "Restored XPath #{xpath}"
      #puts document.xpath("/#{xpath}").to_s
      #
      # Итак, xpath у нас есть. Следующее, что нам нужно сделать - построить
      # RegExp
      #
      # Попробуем сделать так: У нас ведь есть значение текстовое того, что
      # выделено пользователем.
      # 1) Удалим из той ноды, которая расположена по найденному xpath, всякий
      # левый шлак, вроде внутренних тэгов и т.д.
      # 2) А затем тупо, попытаемся найти тот текст, который выделил
      # пользователь в пределах этой ноды. Если найдём - определим его позицию,
      # смещение относительно начала и конца содержимого, и построим regexp

      node = document.xpath("#{xpath}")

      atom_result = node.is_a?(TrueClass) || node.is_a?(FalseClass) || node.is_a?(String)

      # Удаляем все левые ноды, которые не используются для отображения -
      # Такие как <style> <script> <node style="display:none">
      node.xpath('.//*').each do |elem|
        if elem.name =~ /^(script|style)$/
          elem.remove
        end
        if elem.key?('style')
          if elem['style'] =~ /display\s*\:\s*none/
            elem.remove
          end
        end
      end unless atom_result

      inner_html = atom_result ? node.to_s : text_collect(node)
      inner_html.force_encoding("ASCII-8BIT")
      #inner_html = node.inner_html.force_encoding("ASCII-8BIT")
      #p inner_html.encoding()
      # Удаляем тэги
      #inner_html.gsub!(/<!--.*?-->/m, '')
      #inner_html.gsub!(/<[^<]*>/m, '')

      # Заменяем &nbsp; на пробелы. Дело в том, что HTMLEntities превращает
      # &nbsp; в неразрывные пробелы, а это не то, что нам надо.
      #inner_html.gsub!(/&nbsp;/, ' ')
      # Хрень, при парсинге ИНОГДА nokogiri заменяет html entities такие как
      # &nbsp; на unicode символы, это приводит к тому, что мы не можем найти
      # соответстиве выделенного текста тексту в коде страницы. Пытаемся это
      # обрабатывать

      # Удаляем повторяющиеся пробелы, переносы строк
      inner_html.gsub!(/(\302\240)+/, ' ')
      inner_html.gsub!(/\s+/m, ' ')

      # Удаляем пробелы в конца и начале текста
      inner_html.strip!

      #coder = HTMLEntities.new
      #inner_html = coder.decode(inner_html)

      # После decode получаем почему-то опять просто String
      #inner_html.force_encoding("ASCII-8BIT")

      # Также поступаем и с выделенным текстом
      value = sel_text
      value.gsub!(/(\302\240)+/, ' ')
      value.gsub!(/\s+/m, ' ')
      value.strip!

      #inner_html = inner_html.encode(Encoding::UTF_8) rescue inner_html
      #value = value.encode(Encoding::UTF_8) rescue value
      #inner_html.force_encoding("ASCII-8BIT")
      index = inner_html.index(value)
      return unless index

      size = value.size

      pattern = inner_html
      pattern[index..(size + index - 1)] = "&===PATTERN===&"
      pattern = RuleTools.to_regex(pattern)
      pattern.gsub!(/&===PATTERN===&/, keep_text ? "(#{RuleTools.to_regex(value)})" : '(.*?)')

      return xpath, "^#{pattern}$"
    end
  end

  #extract value from document by xpath, regexp
  #result depends on opts
  # :all - return array
  # :first - no produce multiple exception
  def self.extract(document, xpath, regexp, name, opts = {})
    regexp.force_encoding("ASCII-8BIT") unless regexp.frozen?
    parts = regexp.strip.split("\n").map {|part| part.strip.gsub(' /// /// ', ' ///  /// ').split(' /// ') }
    opts = {} unless opts
    result, multi_level, rxpath, breadcrumb_urls = extract_impl2(document, xpath, parts.map {|part| Regexp.new(part[0], Regexp::MULTILINE | Regexp::IGNORECASE)}, name, parts, !opts[:first] && !opts[:all])
    unless result.first || (opts[:validator]||'').empty?
      raise "Validator exception for #{name}" if opts[:source] =~ /#{opts[:validator]}/i
    end

    return opts[:v2] ? [result, breadcrumb_urls] : result if (opts[:all] || multi_level) && !opts[:first]

    dups = {}
    result.each { |el|
      key, val = if el.is_a?(String) || el.is_a?(Numeric)
        ['', el]
      else
        el.first
      end

      raise "Multiple nodes found by [#{key}]: #{rxpath || xpath} (#{result})" if dups[key]

      dups[key] = val
    } unless opts[:first]

    return dups.size > 1 ? dups : (opts[:v2] && result.first) ? [result.first, breadcrumb_urls.first] : result.first
  end

  def self.text_collect(node)
    return "" unless node

    if node.is_a?(Nokogiri::XML::Text)
      text = node.text
      orig_enc = text.encoding
      text.force_encoding("ASCII-8BIT")
      text.gsub!(/(\302\240)+/n, ' ')
      return text.force_encoding(orig_enc)
    end

    texts = []
    if node.is_a?(Nokogiri::XML::NodeSet)
      node.each { |item|
        texts << text_collect(item)
      }
    else
      node.children.each { |child|
        texts << text_collect(child)
      }
    end

    texts.join(' ').gsub(/\s+/, ' ').strip
  end

  def self.extract_impl_cache(document, xpaths, regexps, name, regexp_extended, cache)
    self.extract_impl(document, xpaths, regexps, name, regexp_extended, true, cache)
  end

  def self.extract_impl_cache2(document, xpaths, regexps, name, regexp_extended, cache)
    self.extract_impl2(document, xpaths, regexps, name, regexp_extended, true, cache)
  end

  def self.extract_impl(document, xpaths, regexps, name, regexp_extended = nil, check_duplicated = true, cache = nil)
    self.extract_impl2(document, xpaths, regexps, name, regexp_extended, true, cache)[0..2]
  end

  def self.extract_impl2(document, xpaths, regexps, name, regexp_extended = nil, check_duplicated = true, cache = nil)
    result = []
    breadcrumb_urls = []
    multi_level = false
    used_names = {}
    last_xpath = nil

    xpaths.split("\n").each { |xpath|

      xpath_name = ''
      xpath_name, xpath = xpath.split(':', 2) if name == 'diff'
      xpath_name, xpath = $1, $2 if ['promosother', 'image', 'ean', 'sku', 'tag', 'upc'].include?(name) && xpath =~ /^#(#{name == 'image' ? '[2-9]|1[0-9]|2[0-5]' : name == 'promosother' || name == 'ean' ? '[2-9]' : '[2-4]'}):\s*(.*)$/
      next if used_names[xpath_name]

      xpath_parts = xpath.split(' /// ')

      top_nodes = nil
      if xpath_parts.size > 1 && cache
        top_nodes = cache[xpath_parts.first]
        unless top_nodes
          top_nodes = document.xpath(xpath_parts.first)
          cache[xpath_parts.first] = top_nodes
        end
      end

      root_nodes, xpath_pair, multi_level = xpath_parts.size == 1 ? [[document], xpath, false] : [(top_nodes || document.xpath(xpath_parts.first)), xpath_parts.last, true]
      root_nodes.each { |root_node|
        nodes = (cache||{})[xpath_pair]
        next if nodes == ''

        xpath, xpath_url = xpath_pair.split(' <-- ')

        nodes = root_node.xpath("#{xpath}") if nodes.nil?
        atom_result = nodes.is_a?(TrueClass) || nodes.is_a?(FalseClass) || nodes.is_a?(String) || nodes.is_a?(Float)
        if !atom_result && nodes.empty?
          cache[xpath] = '' if cache && xpath_parts.size == 1
          next
        end

        cache[xpath] = nodes if cache && xpath_parts.size == 1

        (atom_result ? [nodes] : nodes).each { |node|

          unless atom_result
            node = node.dup
            # Удаляем все левые ноды, которые не используются для отображения -
            # Такие как <style> <script> <node style="display:none">
            node.xpath('.//*').each do |elem|
              if elem.name =~ /^(script|style)$/
                elem.remove
              end
              if elem.key?('style')
                if elem['style'] =~ /display\s*:\s*none/i
                  elem.remove
                end
              end
            end
          end

          inner_html = if name == RULE_PART_BREADCRUMB #&& !atom_result
                                                       # We need to know how to split breadcrambs into parts. We can loose
                                                       # this information if we remove all tags from html. That is why we are
                                                       # inserting some divider between tag nodes.

                                                       ##!!!important - use all tags - sometimes we a and span mixed  span >> stan >> a >> a
             text = if atom_result
                      node
                    else
                      node.xpath(".//node()").each {|n|
                        n.add_next_sibling("<span> #{BREADCRUMBS_SEPARATOR} </span>")
                      }
                      node.text
                    end

             orig_enc = text.encoding
             text.force_encoding("ASCII-8BIT")
             text.gsub!(/(\302\240)+/n, ' ')
             text.gsub!(/\s+/, ' ')

             # We can now try to remove redundant separators. Comment this code
             # if it doesn't work well for all cases.

             text.split(/\s*#{Regexp.escape(BREADCRUMBS_SEPARATOR)}\s*/).reject { |s|
               s.force_encoding('utf-8')
               s.size < 2 || !(s =~ /[[:alnum:]]/)
             }.join(" #{BREADCRUMBS_SEPARATOR} ").force_encoding(orig_enc)
=begin

             parts = text.split(/\s+/)

             prev = nil
             prev_char = nil

             keep_chars_inside_part = '|'

             parts.map! {|ls|
               ls.force_encoding(orig_enc)

               keep_char = ls.size == 1 && !keep_chars_inside_part.index(ls[0]).nil? && prev != BREADCRUMBS_SEPARATOR && ls != prev_char
               prev_char = keep_char ? ls : nil

               # .chars can produce exception
               chars_less_2 = begin
                 ls.chars.count {|c| c =~ /[\w]/ || c.bytes.count > 1} < 1
               rescue Exception => e
                 ls.force_encoding('binary')
                 ls.encode!(orig_enc, :invalid => :replace, :undef => :replace)
                 ls.chars.count {|c| c =~ /\w/ || c.bytes.count > 1} < 2
               end

               res = (!keep_char && ls != BREADCRUMBS_SEPARATOR && chars_less_2) ||
                   ((prev == BREADCRUMBS_SEPARATOR || !prev) && ls == BREADCRUMBS_SEPARATOR)

               prev = ls unless res
               res ? nil : ls
             }

             parts.reject! {|s| s.nil?}

             #while ["", BREADCRUMBS_SEPARATOR].include?(parts.first) do parts.shift end
             while ["", BREADCRUMBS_SEPARATOR].include?(parts.last) do parts.pop end

             prevs = {}
             @@html_coder.decode(parts.join(" ").split(" #{BREADCRUMBS_SEPARATOR} ").reject {|part|
               res = prevs[part] || part.strip.empty?
               prevs[part] = true
               res
             }.join(" #{BREADCRUMBS_SEPARATOR} ").force_encoding(orig_enc))

=end

           else
             atom_result ? node.to_s : text_collect(node)
           end

          orig_enc = inner_html.encoding #atom_result ? inner_html.encoding : document.encoding
          inner_html.force_encoding("ASCII-8BIT")
          # FIXME
          # Такие же манипуляции проводятся в методе create_part_v1
          # их нужно вынести в отдельный метод
          #inner_html = node.inner_html.force_encoding("ASCII-8BIT")
          # Удаляем тэги на пробелы
          #can destroy CDATA!!!
          #inner_html.gsub!(/<!--.*?-->/m, ' ')
          #inner_html.gsub!(/<[^<]*>/m, ' ')
          #inner_html.gsub!(/<\/[^<]*>/m, ' ')
          inner_html.gsub!(/<span>/m, ' ')
          inner_html.gsub!(/<\/span>/m, ' ')

          #inner_html.gsub!(/&nbsp;/, ' ')
          # Удаляем повторяющиеся пробелы, переносы строк
          inner_html.gsub!(/(\302\240)+/n, ' ')
          inner_html.gsub!(/\s+/m, ' ')
          # Удаляем пробелы в конца и начале текста
          inner_html.strip!
          # unescapeHTML
          #coder = HTMLEntities.new
          #inner_html = coder.decode(inner_html)
          #inner_html.force_encoding("ASCII-8BIT")

          #special processing - manual
          lresult = []
          regexps.each_with_index { |regexp, idx|
            lresult.compact!
            break if lresult.size > 0

            data = regexp_extended ? regexp_extended[idx] : nil
            if data && data.size > 1
              capture = process_regexp(node, inner_html, data, regexp, (name == RULE_PART_STOCK || name == RULE_PART_INSTORE_STOCK) ? {true => @@PF_IN_STOCK, false => @@PF_OUT_OF_STOCK} : {})
              if capture
                if capture.is_a?(String)
                  capture.force_encoding(orig_enc)
                  #capture.force_encoding(atom_result ? document.encoding : node.text.encoding) #document.encoding)
                  capture.encode!("utf-8") unless capture.encoding.to_s.downcase.start_with?('gb') #chine encodings
                  #cut fucking symbols - see lower too
                  capture = capture.chars.select { |ch| ch if ch.bytes.size < 4 }.join
                  capture = @@html_coder.decode(capture)
                end
                lresult << capture if capture.to_s.size > 0
              end
              next
            end

            # Проверяем регулярное выражение
            match = regexp.match(inner_html)

            next if !match

            capture = match.captures.first

            raise "Incorrect regexp for #{name}: #{regexp}/#{regexp.encoding.to_s}. Specify capture group. Text #{inner_html[0..50]} #{inner_html.encoding}" if !capture #in case matching without groups - no capture

            case name
              when RULE_PART_PRICE, RULE_PART_SECOND_PRICE, RULE_PART_REGULAR_PRICE, RULE_PART_DELIVERY_PRICE
                price = extract_price(capture, xpath)
                next unless price
                lresult << price
              when RULE_PART_IMAGE
                lresult << capture.gsub(/\/\d+\.\d+\.\d+\.\d+\/bmi\//, '/') if capture.size > 0
              else

                #capture.encode!(orig_enc, :invalid => :replace, :undef => :replace, :replace => '')
                capture.force_encoding(orig_enc)
                capture.encode!("utf-8") unless capture.encoding.to_s.downcase.start_with?('gb') #chine encodings
                #cut fucking symbols - see upped too
                capture = capture.chars.select { |ch| ch if ch.bytes.size < 4 }.join
                capture.strip!
                if capture.size > 0
                  lresult << capture
                  breadcrumb_urls << node.xpath(xpath_url).text if name == RULE_PART_BREADCRUMB && xpath_url
                end

=begin
                if document.respond_to?(:encoding) # Fix for new tests
                  raise "Unexpected null capture #{name}: #{regexp}" unless capture
                  raise "Unexpected null document encoding" unless document.encoding
                  capture.strip!
                  if capture.size > 0 #empty content - meabs not found
                    capture.force_encoding(atom_result ? document.encoding : node.text.encoding)
                    capture.encode!("utf-8") unless capture.encoding.to_s.downcase.start_with?('gb') #chine encodings
                    lresult << capture
                  end
                else
                  if capture && capture.strip.size > 0
                    lresult << capture.strip
                  end
                end
=end
            end
          } #regexprs

          lresult.compact!
          raise "Multiple (#{lresult.size}) nodes found: #{xpath} (#{lresult.join(' /// ')})" if check_duplicated && lresult.size > 1
          lresult.each { |val|
            #val.force_encoding('UTF-8') if val.is_a?(String)
            used_names[xpath_name] = true
            result << (xpath_name.empty? ? val : name == 'diff' ? {xpath_name => val.to_s.strip}.to_json.to_s : {xpath_name => val.to_s.strip})
          }
        } #nodes
      } #root_nodes
      last_xpath = xpath
      break if !result.empty? && !['image', 'ean', 'diff', 'sku', 'upc', 'tag', 'promosother'].include?(name) # name != 'diff' && name != 'image'
    } #xpaths

    [(name == 'diff' && result.size > 0 ? ["[#{result.join(',')}]"] : result), multi_level, last_xpath, breadcrumb_urls]
  end

  def self.extract_price(capture, expr = nil)
    return nil unless capture

    prices = []
    capture.force_encoding('BINARY').gsub(/([\d\.,])\s+([\d\.,])/, '\1\2').gsub(/([\d\.,])\s+([\d\.,])/, '\1\2').strip.scan(/[\d\.,]+/) { |price|
      prices << price if price =~ /\d/
    }

    return nil if prices.empty?
    raise "Too many possible prices #{prices} found in string: #{capture} by expr #{expr}" if prices.size > 1

    price = prices.first

    #manage dots commas
    #125,12.33 => 12512.33
    #125.12,33 => 12512.33

    last_pos = price.rindex(/[\.,]/)
    if last_pos && last_pos >= price.size - 3 && last_pos != price.size - 1 #2 digits - kopeyki
      return Float(price[0..last_pos].gsub(/[\.,]/, '') + price[last_pos..-1].gsub(/[\.,]/, '.'))
    end

    Float(price.gsub(/[\.,]/, ''))
  end

  def self.month_idx(month)
    month2idx = {
        'jan' => 1, 'januari' => 1, 'january' => 1, 'ene' => 1, 'janvier' => 1, 'janv' => 1, 'januar' => 1, 'gennaio' => 1, 'enero' => 1, 'ocak' => 1,
        'feb' => 2, 'februari' => 2, 'february' => 2, 'febrero' => 2, 'fev' => 2, "f\u00e9vrier" => 2, 'februar' => 2, 'febbraio' => 2, 'şubat' => 2,
        'mar' => 3, 'march' => 3, 'marzo' => 3, 'maart' => 3, 'spring' => 3, 'mars' => 3, 'märz' => 3, 'mart' => 3,
        'april' => 4, 'abril' => 4, 'abr' => 4, 'apr' => 4, 'avril' => 4, 'aprile' => 4, 'nisan' => 4,
        'may' => 5, 'mayo' => 5, 'mai' => 5, 'maggio' => 5, 'può' => 5, 'mayoe' => 5, 'mayıs' => 5,
        'jun' => 6, 'june' => 6, 'Junho' => 6, 'giu' => 6, 'juin' => 6, 'giugno' => 6, 'junio' => 6, 'haziran' => 6,
        'jul' => 7, 'july' => 7, 'julho' => 7, 'lug' => 7, 'juil' => 7, 'juillet' => 7, 'luglio' => 7, 'julio' => 7, 'temmuz' => 7,
        'aug' => 8, 'august' => 8, 'agosto' => 8, 'ago' => 8, "ao\u00fbt" => 8, 'ağustos' => 8,
        'sep' => 9, 'sept' => 9, 'september' => 9, 'set' => 9, 'septembre' => 9, 'settembre' => 9, 'septiembre' => 9, 'eylül' => 9,
        'oct' => 10, 'oktober' => 10, 'october' => 10, 'out' => 10, 'octobre' => 10, 'ottobre' => 10, 'oktobre' => 10, 'octubre' => 10, 'ekim' => 10,
        'nov' => 11, 'november' => 11, 'novembre' => 11, 'noviembre' => 11, 'kasım' => 11,
        'dec' => 12, 'dic' => 12, 'december' => 12, 'dez' => 12, 'decembre' => 12, 'dezember' => 12, 'décembre' => 12, "d\u00e9cembre" => 12, 'dicembre' => 12, 'diciembre' => 12, 'ara' => 12
        #'января' => 1, 'февраля' => 2, 'марта' => 3, 'апреля' => 4, 'мая' => 5, 'июня' => 6, 'июля' => 7, 'августа' => 8, 'сентября' => 9, 'октября' => 10, 'ноября' => 11, 'декабря' => 12
    }

    return month2idx[month]
  end

  #use in rule editor
  def self.pf_date(y, m, d)

    month = month_idx(m.force_encoding('utf-8').downcase) || month_idx(m.downcase + '.') if m.is_a?(String)
    month = m.to_i unless month

    unless y
      if month < Time.now.month
        y = Time.now.year + 1
      else
        y = Time.now.year
      end
    end

    year = y.to_i
    year += 2000 if year < 70 and year > 5
    raise "Strange year in stock: #{y}/#{m}/#{d}" if year < 2000 || year > 2100
    day = d.to_i
    raise "Incorrect month: '#{m}' #{m.to_s.encoding}" if month < 1 || month > 12
    raise "Incorrect day: '#{d}'" if day < 1 || day > 31
    Time.new(year, month, day)
  end

  def self.pf_stock(y, m, d, period_days = 4)
    #y = y.to_i
  	#raise "Strange year in pf_stock: #{y}" if y < 2000 || y > 2200
    return (pf_date(y, m, d).to_i - Time.now.to_i) / (60 * 60 * 24) <= period_days ? @@PF_IN_STOCK : @@PF_OUT_OF_STOCK
  end

  def self.pf_in_stock?(in_stock)
    in_stock ? pf_in_stock : pf_out_of_stock
  end

  def self.pf_in_stock
    @@PF_IN_STOCK
  end

  def self.pf_out_of_stock
    @@PF_OUT_OF_STOCK
  end

  def self.now
    Time.now
  end

  def self.Now
    Time.now
  end

  def self.compile_rule(rule)
    rule[:parts].each {|part|
      if part[:regexp].strip.empty?
        part[:regexp] = nil
      else
        puts "Compiling: #{part[:regexp]}"
        part[:regexp] = part[:regexp].strip.split("\n").map {|regexp|
          parts = regexp.strip.gsub(' /// /// ', ' ///  /// ').split(' /// ')
          [
            Regexp.new(parts[0], Regexp::MULTILINE | Regexp::IGNORECASE),
            parts[1] ? parts[1].freeze : nil,
            parts[2] ? parts[2].freeze : nil
          ].compact
        }
      end
    }
  end

  def self.pf_attrs(node, xpath, n, v)
    node.xpath(xpath).map {|x|
      key = x.xpath(n)
      key = key.is_a?(String) ? key.to_s : RuleTools.text_collect(key)
      key.gsub!("\xC2\xA0", ' ') rescue nil
      key = key.gsub(/\s+/, ' ').strip
      val = x.xpath(v)
      val = val.is_a?(String) ? val.to_s : RuleTools.text_collect(val)
      val.gsub!("\xC2\xA0", ' ') rescue nil
      val = val.gsub(/\s+/, ' ').strip
      "#{key}::: #{val}" unless key.empty? || val.empty?
    }.compact.join(';;; ')
  end

  #used for stock processing
  #original stock text can be formatted by mask or processed by script
  #node - parameter can be used in script!!!!
  def self.process_regexp(node_for_script, value, parts, regexp = nil, mapping = {})
    return nil unless parts
    parts = parts.gsub(' /// /// ', ' ///  /// ').split(' /// ') if parts.is_a?(String)

    unless regexp
      regexp = parts[0].is_a?(String) ? Regexp.new(parts[0].force_encoding('BINARY'), Regexp::MULTILINE | Regexp::IGNORECASE) : parts[0]
    end

    m = regexp.match((value && value.is_a?(String) && value.encoding == regexp.encoding) ? value : "#{value}".to_s.force_encoding('BINARY'))
    raise "No capture specified in expression: #{parts[0]} in #{value}" if m && m.captures.size == 0 && parts.size != 2
    if m && m.captures.size > 0
      mask = "#{parts[1]}"
      script = "#{parts[2]}".strip

      raise "Incorrect smart expression. Capture without mask or script: #{parts[0]}" if mask.empty? && script.empty?

      m.captures.each_with_index { |capt,idx|
        raise "Incorrect expression specified: '#{parts[0]}' for '#{value}'" unless capt
        mask.gsub!("{#{idx}}", capt)
        script.gsub!("{#{idx}}", capt)
        mask.gsub!("{o}", capt) if idx == 0
        mask.gsub!("{O}", capt) if idx == 0
      }
      #9 parameters supported
      (m.captures.size..9).each { |idx|
        mask.gsub!("{#{idx}}", '')
        script.gsub!("{#{idx}}", '')
      }
      value = mask unless mask.strip.empty?

      unless script.strip.empty?
        #normalize call - octal 09
        base_script = script

        script.gsub!('{mask}', "'#{mask.gsub("\\", "\\\\").gsub("'", "\\'")}'")

        script.gsub!(/pf_stock\s*\(([\w\.]+)\s*,\s*([\w'"]+)\s*,\s*([\w\.]+)\s*\)/) { |s|
          y, m, d = $1, $2, $3
          "pf_stock(#{y =~ /\d+/ ? y.to_i : y}, #{m =~ /\d+/ ? m.to_i : m}, #{d =~ /\d+/ ? d.to_i : d})"
        }
        result = begin
          #used inside eval
          node = node_for_script
          eval(script || node) # :) tricky code
        rescue Exception => e
          p e.message
          p e.backtrace
          p script
          raise "Error inside expression: [#{regexp}] [#{base_script}] -> [#{script}] for #{value[0..250].encode('binary', :invalid => :replace, :undef => :replace, :replace => '')}, #{e.message}"
        end
	      return mapping[result] if !(mapping||{}).empty? && (result.is_a?(TrueClass) || result.is_a?(FalseClass))
        return result
      end
    else
      value = nil
    end

    value
  end
end
