import elm from "rollup-plugin-elm";

export default [
  {
    input: "./src/server.js",
    output: {
      file: `dist/app.js`,
      format: "cjs"
    },
    plugins: [
      elm({
        exclude: "elm_stuff/**"
      })
    ]
  }
];
