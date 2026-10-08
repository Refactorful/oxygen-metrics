module Fetch = {
  type response

  @val external fetch: string => promise<response> = "fetch"
  @send external json: response => promise<'a> = "json"
}
