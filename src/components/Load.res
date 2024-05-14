let queryClient = ReactQuery.QueryClient.make()

@spice
type githubData = {
    name: string,
    description: string,
    subscribers_count: int,
    stargazers_count: int,
    forks_count: int,
}

module Page = {

  @react.component
  let make = () => {
    let {status, error, data, isFetching} = ReactQuery.useQuery({
        queryKey: [],
        queryFn: async _ => {
            let response = await Fetch.get("https://api.github.com/repos/TanStack/query")
            let data = await response -> Fetch.Response.json
            data->githubData_decode
        },
    })
    
    switch (status, data) {
    | (Pending, _) => <p> {"Loading..."->React.string} </p>
    | (Error, _) =>
      <div>
        <p> {"An error occured"->React.string} </p>
        {error->Option.flatMap(e => Js.Exn.message(e))->Option.mapOr(React.null, React.string)}
      </div>
    | (Success, Error(_)) =>
        {Js.log(data)}
        <div>
            <p> {"Recieved invalid data structure"->React.string} </p>
        </div>
    | (Success, Ok(s)) =>
        <div className="p-4 rounded border inline-flex flex-col m-4">
            <h1> {s.name->React.string} </h1>
            <p> {s.description->React.string} </p>
            <strong> {`👀 ${s.subscribers_count->Int.toString}`->React.string} </strong>
            <strong> {`✨ ${s.stargazers_count->Int.toString}`->React.string} </strong>
            <strong> {`🍴 ${s.forks_count->Int.toString}`->React.string} </strong>
            <div> {isFetching ? "Updating..."->React.string : React.null} </div>
        </div>
    }
  }
}

@react.component
let make = () => {
  <ReactQuery.QueryClientProvider client={queryClient}>
    <Page />
    <ReactQuery.ReactQueryDevtools initialIsOpen={true} />
  </ReactQuery.QueryClientProvider>
}
