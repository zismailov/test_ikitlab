require "net/http"

class Parser::ScraperService
  def initialize(character)
    @character = character
    @country = "RUS"
    @url = "https://certification.pmi.org/registry.aspx"
    @viewstate = "/wEPDwUJMTE5MTEyOTU2D2QWAgIDD2QWAgIDDxQrAAMPBYIBQztDOlBNSS5XZWIuRnJhbWV3b3JrLkR5bmFtaWNQbGFjZWhvbGRlciwgUE1JLldlYiwgVmVyc2lvbj0yLjAuNjg0OS4yNDA4NiwgQ3VsdHVyZT1uZXV0cmFsLCBQdWJsaWNLZXlUb2tlbj1udWxsO0NvbnRlbnRQbGFjZWhvbGRlchYBDwVEQztVQzpBU1AucmVnaXN0cnlfcmVnaXN0cnljb250ZW50X2FzY3g6L1JlZ2lzdHJ5O2RwaF9SZWdpc3RyeUNvbnRlbnQWAGRkFgJmD2QWAmYPZBYEAgcPEGQPFvgBZgIBAgICAwIEAgUCBgIHAggCCQIKAgsCDAINAg4CDwIQAhECEgITAhQCFQIWAhcCGAIZAhoCGwIcAh0CHgIfAiACIQIiAiMCJAIlAiYCJwIoAikCKgIrAiwCLQIuAi8CMAIxAjICMwI0AjUCNgI3AjgCOQI6AjsCPAI9Aj4CPwJAAkECQgJDAkQCRQJGAkcCSAJJAkoCSwJMAk0CTgJPAlACUQJSAlMCVAJVAlYCVwJYAlkCWgJbAlwCXQJeAl8CYAJhAmICYwJkAmUCZgJnAmgCaQJqAmsCbAJtAm4CbwJwAnECcgJzAnQCdQJ2AncCeAJ5AnoCewJ8An0CfgJ/AoABAoEBAoIBAoMBAoQBAoUBAoYBAocBAogBAokBAooBAosBAowBAo0BAo4BAo8BApABApEBApIBApMBApQBApUBApYBApcBApgBApkBApoBApsBApwBAp0BAp4BAp8BAqABAqEBAqIBAqMBAqQBAqUBAqYBAqcBAqgBAqkBAqoBAqsBAqwBAq0BAq4BAq8BArABArEBArIBArMBArQBArUBArYBArcBArgBArkBAroBArsBArwBAr0BAr4BAr8BAsABAsEBAsIBAsMBAsQBAsUBAsYBAscBAsgBAskBAsoBAssBAswBAs0BAs4BAs8BAtABAtEBAtIBAtMBAtQBAtUBAtYBAtcBAtgBAtkBAtoBAtsBAtwBAt0BAt4BAt8BAuABAuEBAuIBAuMBAuQBAuUBAuYBAucBAugBAukBAuoBAusBAuwBAu0BAu4BAu8BAvABAvEBAvIBAvMBAvQBAvUBAvYBAvcBFvgBEAUQU2VsZWN0IGEgQ291bnRyeQUBMGcQBQtBZmdoYW5pc3RhbgUDQUZHZxAFDsOFbGFuZCBJc2xhbmRzBQNBTEFnEAUHQWxiYW5pYQUDQUxCZxAFB0FsZ2VyaWEFA0RaQWcQBQ5BbWVyaWNhbiBTYW1vYQUDQVNNZxAFB0FuZG9ycmEFA0FORGcQBQZBbmdvbGEFA0FHT2cQBQhBbmd1aWxsYQUDQUlBZxAFCkFudGFyY3RpY2EFA0FUQWcQBRNBbnRpZ3VhIGFuZCBCYXJidWRhBQNBVEdnEAUJQXJnZW50aW5hBQNBUkdnEAUHQXJtZW5pYQUDQVJNZxAFBUFydWJhBQNBQldnEAUJQXVzdHJhbGlhBQNBVVNnEAUHQXVzdHJpYQUDQVVUZxAFCkF6ZXJiYWlqYW4FA0FaRWcQBQdCYWhhbWFzBQNCSFNnEAUHQmFocmFpbgUDQkhSZxAFCkJhbmdsYWRlc2gFA0JHRGcQBQhCYXJiYWRvcwUDQlJCZxAFB0JlbGFydXMFA0JMUmcQBQdCZWxnaXVtBQNCRUxnEAUGQmVsaXplBQNCTFpnEAUFQmVuaW4FA0JFTmcQBQdCZXJtdWRhBQNCTVVnEAUGQmh1dGFuBQNCVE5nEAUHQm9saXZpYQUDQk9MZxAFIEJvbmFpcmUsIFNpbnQgRXVzdGF0aXVzIGFuZCBTYWJhBQNCRVNnEAUWQm9zbmlhIGFuZCBIZXJ6ZWdvdmluYQUDQklIZxAFCEJvdHN3YW5hBQNCV0FnEAUNQm91dmV0IElzbGFuZAUDQlZUZxAFBkJyYXppbAUDQlJBZxAFHkJyaXRpc2ggSW5kaWFuIE9jZWFuIFRlcnJpdG9yeQUDSU9UZxAFFkJyaXRpc2ggVmlyZ2luIElzbGFuZHMFA1ZHQmcQBRFCcnVuZWkgRGFydXNzYWxhbQUDQlJOZxAFCEJ1bGdhcmlhBQNCR1JnEAUMQnVya2luYSBGYXNvBQNCRkFnEAUHQnVydW5kaQUDQkRJZxAFCENhbWJvZGlhBQNLSE1nEAUIQ2FtZXJvb24FA0NNUmcQBQZDYW5hZGEFA0NBTmcQBQpDYXBlIFZlcmRlBQNDUFZnEAUOQ2F5bWFuIElzbGFuZHMFA0NZTWcQBRhDZW50cmFsIEFmcmljYW4gUmVwdWJsaWMFA0NBRmcQBQRDaGFkBQNUQ0RnEAUFQ2hpbGUFA0NITGcQBQ9DaGluYSwgbWFpbmxhbmQFA0NITmcQBRBDaHJpc3RtYXMgSXNsYW5kBQNDWFJnEAUXQ29jb3MgKEtlZWxpbmcpIElzbGFuZHMFA0NDS2cQBQhDb2xvbWJpYQUDQ09MZxAFB0NvbW9yb3MFA0NPTWcQBRBDb25nbywgRGVtLiBSZXAuBQNDT0RnEAULQ29uZ28sIFJlcC4FA0NPR2cQBQxDb29rIElzbGFuZHMFA0NPS2cQBQpDb3N0YSBSaWNhBQNDUklnEAUOQ8O0dGUgZCdJdm9pcmUFA0NJVmcQBQdDcm9hdGlhBQNIUlZnEAUEQ3ViYQUDQ1VCZxAFCEN1cmHDp2FvBQNDVVdnEAUGQ3lwcnVzBQNDWVBnEAUOQ3plY2ggUmVwdWJsaWMFA0NaRWcQBQdEZW5tYXJrBQNETktnEAUIRGppYm91dGkFA0RKSWcQBQhEb21pbmljYQUDRE1BZxAFEkRvbWluaWNhbiBSZXB1YmxpYwUDRE9NZxAFB0VjdWFkb3IFA0VDVWcQBQVFZ3lwdAUDRUdZZxAFC0VsIFNhbHZhZG9yBQNTTFZnEAURRXF1YXRvcmlhbCBHdWluZWEFA0dOUWcQBQdFcml0cmVhBQNFUklnEAUHRXN0b25pYQUDRVNUZxAFCEV0aGlvcGlhBQNFVEhnEAUhRmFsa2xhbmQgSXNsYW5kcyAoSXNsYXMgTWFsdmluYXMpBQNGTEtnEAUNRmFyb2UgSXNsYW5kcwUDRlJPZxAFHkZlZGVyYXRlZCBTdGF0ZXMgb2YgTWljcm9uZXNpYQUDRlNNZxAFBEZpamkFA0ZKSWcQBQdGaW5sYW5kBQNGSU5nEAUGRnJhbmNlBQNGUkFnEAUNRnJlbmNoIEd1aWFuYQUDR1VGZxAFEEZyZW5jaCBQb2x5bmVzaWEFA1BZRmcQBRtGcmVuY2ggU291dGhlcm4gVGVycml0b3JpZXMFA0FURmcQBQVHYWJvbgUDR0FCZxAFBkdhbWJpYQUDR01CZxAFB0dlb3JnaWEFA0dFT2cQBQdHZXJtYW55BQNERVVnEAUFR2hhbmEFA0dIQWcQBQlHaWJyYWx0YXIFA0dJQmcQBQZHcmVlY2UFA0dSQ2cQBQlHcmVlbmxhbmQFA0dSTGcQBQdHcmVuYWRhBQNHUkRnEAUKR3VhZGVsb3VwZQUDR0xQZxAFBEd1YW0FA0dVTWcQBQlHdWF0ZW1hbGEFA0dUTWcQBQZHdWluZWEFA0dJTmcQBQ1HdWluZWEtQmlzc2F1BQNHTkJnEAUGR3V5YW5hBQNHVVlnEAUFSGFpdGkFA0hUSWcQBSFIZWFyZCBJc2xhbmQgYW5kIE1jRG9uYWxkIElzbGFuZHMFA0hNRGcQBQhIb25kdXJhcwUDSE5EZxAFCUhvbmcgS29uZwUDSEtHZxAFB0h1bmdhcnkFA0hVTmcQBQdJY2VsYW5kBQNJU0xnEAUFSW5kaWEFA0lORGcQBQlJbmRvbmVzaWEFA0lETmcQBRlJcmFuLCBJc2xhbWljIFJlcHVibGljIG9mBQNJUk5nEAUESXJhcQUDSVJRZxAFB0lyZWxhbmQFA0lSTGcQBQZJc3JhZWwFA0lTUmcQBQVJdGFseQUDSVRBZxAFB0phbWFpY2EFA0pBTWcQBQVKYXBhbgUDSlBOZxAFBkpvcmRhbgUDSk9SZxAFCkthemFraHN0YW4FA0tBWmcQBQVLZW55YQUDS0VOZxAFCEtpcmliYXRpBQNLSVJnEAUGS3V3YWl0BQNLV1RnEAUKS3lyZ3l6c3RhbgUDS0daZxAFBExhb3MFA0xBT2cQBQZMYXR2aWEFA0xWQWcQBQdMZWJhbm9uBQNMQk5nEAUHTGVzb3RobwUDTFNPZxAFB0xpYmVyaWEFA0xCUmcQBQVMaWJ5YQUDTEJZZxAFDUxpZWNodGVuc3RlaW4FA0xJRWcQBQlMaXRodWFuaWEFA0xUVWcQBQpMdXhlbWJvdXJnBQNMVVhnEAUFTWFjYW8FA01BQ2cQBSpNYWNlZG9uaWEsIFRoZSBGb3JtZXIgWXVnb3NsYXYgUmVwdWJsaWMgb2YFA01LRGcQBQpNYWRhZ2FzY2FyBQNNREdnEAUGTWFsYXdpBQNNV0lnEAUITWFsYXlzaWEFA01ZU2cQBQhNYWxkaXZlcwUDTURWZxAFBE1hbGkFA01MSWcQBQVNYWx0YQUDTUxUZxAFEE1hcnNoYWxsIElzbGFuZHMFA01ITGcQBQpNYXJ0aW5pcXVlBQNNVFFnEAUKTWF1cml0YW5pYQUDTVJUZxAFCU1hdXJpdGl1cwUDTVVTZxAFB01heW90dGUFA01ZVGcQBQZNZXhpY28FA01FWGcQBRRNb2xkb3ZhLCBSZXB1YmxpYyBvZgUDTURBZxAFBk1vbmFjbwUDTUNPZxAFCE1vbmdvbGlhBQNNTkdnEAUKTW9udGVuZWdybwUDTU5FZxAFCk1vbnRzZXJyYXQFA01TUmcQBQdNb3JvY2NvBQNNQVJnEAUKTW96YW1iaXF1ZQUDTU9aZxAFB015YW5tYXIFA01NUmcQBQdOYW1pYmlhBQNOQU1nEAUFTmF1cnUFA05SVWcQBQVOZXBhbAUDTlBMZxAFC05ldGhlcmxhbmRzBQNOTERnEAUUTmV0aGVybGFuZHMgQW50aWxsZXMFA0FOVGcQBQ1OZXcgQ2FsZWRvbmlhBQNOQ0xnEAULTmV3IFplYWxhbmQFA05aTGcQBQlOaWNhcmFndWEFA05JQ2cQBQVOaWdlcgUDTkVSZxAFB05pZ2VyaWEFA05HQWcQBQROaXVlBQNOSVVnEAUOTm9yZm9sayBJc2xhbmQFA05GS2cQBQtOb3J0aCBLb3JlYQUDUFJLZxAFGE5vcnRoZXJuIE1hcmlhbmEgSXNsYW5kcwUDTU5QZxAFBk5vcndheQUDTk9SZxAFBE9tYW4FA09NTmcQBQhQYWtpc3RhbgUDUEFLZxAFBVBhbGF1BQNQTFdnEAUTUGFsZXN0aW5lLCBTdGF0ZSBvZgUDUFNFZxAFBlBhbmFtYQUDUEFOZxAFEFBhcHVhIE5ldyBHdWluZWEFA1BOR2cQBQhQYXJhZ3VheQUDUFJZZxAFBFBlcnUFA1BFUmcQBQtQaGlsaXBwaW5lcwUDUEhMZxAFCFBpdGNhaXJuBQNQQ05nEAUGUG9sYW5kBQNQT0xnEAUIUG9ydHVnYWwFA1BSVGcQBQtQdWVydG8gUmljbwUDUFJJZxAFBVFhdGFyBQNRQVRnEAUIUsOpdW5pb24FA1JFVWcQBQdSb21hbmlhBQNST1VnEAUSUnVzc2lhbiBGZWRlcmF0aW9uBQNSVVNnEAUGUndhbmRhBQNSV0FnEAURU2FpbnQgQmFydGjDqWxlbXkFA0JMTWcQBQxTYWludCBIZWxlbmEFA1NITmcQBRVTYWludCBLaXR0cyBhbmQgTmV2aXMFA0tOQWcQBQtTYWludCBMdWNpYQUDTENBZxAFGlNhaW50IE1hcnRpbiAoRnJlbmNoIHBhcnQpBQNNQUZnEAUgU2FpbnQgVmluY2VudCBhbmQgdGhlIEdyZW5hZGluZXMFA1ZDVGcQBRlTYWludC1QaWVycmUgYW5kIE1pcXVlbG9uBQNTUE1nEAUFU2Ftb2EFA1dTTWcQBQpTYW4gTWFyaW5vBQNTTVJnEAUYU8OjbyBUb23DqSBhbmQgUHLDrW5jaXBlBQNTVFBnEAUMU2F1ZGkgQXJhYmlhBQNTQVVnEAUHU2VuZWdhbAUDU0VOZxAFBlNlcmJpYQUDU1JCZxAFClNleWNoZWxsZXMFA1NZQ2cQBQxTaWVycmEgTGVvbmUFA1NMRWcQBQlTaW5nYXBvcmUFA1NHUGcQBRlTaW50IE1hYXJ0ZW4gKER1dGNoIHBhcnQpBQNTWE1nEAUIU2xvdmFraWEFA1NWS2cQBQhTbG92ZW5pYQUDU1ZOZxAFD1NvbG9tb24gSXNsYW5kcwUDU0xCZxAFB1NvbWFsaWEFA1NPTWcQBQxTb3V0aCBBZnJpY2EFA1pBRmcQBSxTb3V0aCBHZW9yZ2lhIGFuZCB0aGUgU291dGggU2FuZHdpY2ggSXNsYW5kcwUDU0dTZxAFC1NvdXRoIEtvcmVhBQNLT1JnEAULU291dGggU3VkYW4FA1NTRGcQBQVTcGFpbgUDRVNQZxAFCVNyaSBMYW5rYQUDTEtBZxAFBVN1ZGFuBQNTRE5nEAUIU3VyaW5hbWUFA1NVUmcQBRZTdmFsYmFyZCBhbmQgSmFuIE1heWVuBQNTSk1nEAUJU3dhemlsYW5kBQNTV1pnEAUGU3dlZGVuBQNTV0VnEAULU3dpdHplcmxhbmQFA0NIRWcQBRRTeXJpYW4gQXJhYiBSZXB1YmxpYwUDU1lSZxAFGlRhaXdhbiAoUmVwdWJsaWMgb2YgQ2hpbmEpBQNUV05nEAUKVGFqaWtpc3RhbgUDVEpLZxAFHFRhbnphbmlhLCBVbml0ZWQgUmVwdWJsaWMgT2YFA1RaQWcQBQhUaGFpbGFuZAUDVEhBZxAFC1RpbW9yLUxlc3RlBQNUTFNnEAUEVG9nbwUDVEdPZxAFB1Rva2VsYXUFA1RLTGcQBQVUb25nYQUDVE9OZxAFE1RyaW5pZGFkIGFuZCBUb2JhZ28FA1RUT2cQBQdUdW5pc2lhBQNUVU5nEAUGVHVya2V5BQNUVVJnEAUMVHVya21lbmlzdGFuBQNUS01nEAUYVHVya3MgYW5kIENhaWNvcyBJc2xhbmRzBQNUQ0FnEAUGVHV2YWx1BQNUVVZnEAUTVS5TLiBWaXJnaW4gSXNsYW5kcwUDVklSZxAFBlVnYW5kYQUDVUdBZxAFB1VrcmFpbmUFA1VLUmcQBRRVbml0ZWQgQXJhYiBFbWlyYXRlcwUDQVJFZxAFDlVuaXRlZCBLaW5nZG9tBQNHQlJnEAUNVW5pdGVkIFN0YXRlcwUDVVNBZxAFJFVuaXRlZCBTdGF0ZXMgTWlub3IgT3V0bHlpbmcgSXNsYW5kcwUDVU1JZxAFB1VydWd1YXkFA1VSWWcQBQpVemJla2lzdGFuBQNVWkJnEAUHVmFudWF0dQUDVlVUZxAFB1ZhdGljYW4FA1ZBVGcQBQlWZW5lenVlbGEFA1ZFTmcQBQhWaWV0IE5hbQUDVk5NZxAFEVdhbGxpcyBhbmQgRnV0dW5hBQNXTEZnEAUOV2VzdGVybiBTYWhhcmEFA0VTSGcQBQVZZW1lbgUDWUVNZxAFBlphbWJpYQUDWk1CZxAFCFppbWJhYndlBQNaV0VnFgFmZAIJDxBkDxYJZgIBAgICAwIEAgUCBgIHAggWCRAFA0FsbAUBMGcQBQNQTVAFATFnEAUEQ0FQTQUBMmcQBQRQZ01QBQEzZxAFB1BNSS1STVAFATRnEAUGUE1JLVNQBQE1ZxAFB1BNSS1BQ1AFATZnEAUEUGZNUAUBN2cQBQdQTUktUEJBBQE4ZxYBZmQYAQUeX19Db250cm9sc1JlcXVpcmVQb3N0QmFja0tleV9fFgIFHEhlYWRlcjEkUE1JTG9naW5TdGF0dXMkY3RsMDEFHEhlYWRlcjEkUE1JTG9naW5TdGF0dXMkY3RsMDPSY5yy227ecVut51O0PQGoH2dKVw=="
  end

  def call
    get_attributes
  end

  private

  def get_attributes
    page = Nokogiri::HTML(get_html.to_s)
    Parser::PageService.new(page).call
  end

  def get_html
    uri = URI(@url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    post_request = Net::HTTP::Post.new(uri.path, headers)

    post_request.body = request_body
    response = https.request(post_request)

    gz = Zlib::GzipReader.new(StringIO.new(response.body.to_s))
    gz.read
  end

  def headers
    @headers ||= {
      "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
      "Accept-Encoding" => "gzip, deflate",
      "Accept-Language" => "ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4",
      "Upgrade-Insecure-Requests" => "1",
      "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36",
      "Content-Type" => "application/x-www-form-urlencoded",
      "Origin" => "https://certification.pmi.org",
      "Cache-Control" => "no-cache",
      "Referer" => "https://certification.pmi.org/registry.aspx",
      "Connection" => "keep-alive"
    }
  end

  def request_body
    request_body = ""
    data.each do |key, value|
      request_body += "#{key}=#{value}&"
    end
    request_body
  end

  def data
    @data ||= {
      "__EVENTTARGET" => "",
      "__EVENTARGUMENT" => "",
      "__VIEWSTATE" => @viewstate,
      "dph_RegistryContent$tbSearch" => @character,
      "dph_RegistryContent$firstNameTextBox" => "",
      "dph_RegistryContent$wcountry" => @country,
      "dph_RegistryContent$credentialDDL" => 0,
      "dph_RegistryContent_Button1" => "Search"
    }
  end
end
