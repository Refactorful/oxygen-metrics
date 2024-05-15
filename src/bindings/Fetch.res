module Fetch = {
  type response

  @val external fetch: string => Js.Promise.t<response> = "fetch"
  @send external json: response => Js.Promise.t<'a> = "json"
}
