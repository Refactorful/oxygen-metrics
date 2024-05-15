open ReactQuery
open Fetch

@spice
type githubData = {
    name: string,
    description: string,
    subscribers_count: int,
    stargazers_count: int,
    forks_count: int,
}

let apiUrl = "https://api.github.com/repos/TanStack/query"

let fetchTodos = (_): Js.Promise.t<githubData> => {
  Fetch.fetch(apiUrl)->Promise.then(Fetch.json)
}

module Page = {
// 
  @react.component
  let make = () => {

    let queryResult = ReactQuery.useQuery({
        queryKey: [],
        queryFn: fetchTodos,
        refetchInterval: ReactQuery.refetchInterval(#number(3 * 1000)),
    })

    <div>
        {switch queryResult {
        | {isLoading: true} => "Loading..."->React.string
        | {isError: true, error: Value(e)} => e -> Js.Json.stringify->React.string
        | {data: Some(s), isLoading: false, isError: false} =>
            <div className="p-4 rounded border inline-flex flex-col m-4">
                <h1> {s.name->React.string} </h1>
                <p> {s.description->React.string} </p>
                <strong> {`👀 ${s.subscribers_count->Int.toString}`->React.string} </strong>
                <strong> {`✨ ${s.stargazers_count->Int.toString}`->React.string} </strong>
                <strong> {`🍴 ${s.forks_count->Int.toString}`->React.string} </strong>
            </div>
        | _ => `Unexpected error...`->React.string
      }}
    </div>
    
  }
}


let client = ReactQuery.Provider.createClient()


@react.component
let make = () => {
  <ReactQuery.Provider client>
      <ReactQuery.DevTools initialIsOpen={false}/>
    <Page />
  </ReactQuery.Provider>
}
