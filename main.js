import "./style.css"
import { Elm } from "./src/Main.elm"
import OBSWebSocket from "obs-websocket-js"

const obs = new OBSWebSocket()

obs.connect()
obs.on("AuthenticationSuccess", () => {
  obs.call("GetSceneList").then((data) => console.log(data))
  obs.call("GetInputList").then((data) => console.log(data))
})

const root = document.querySelector("#app div")
const app = Elm.Main.init({ node: root })
