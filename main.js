import "./style.css"
import { Elm } from "./src/Main.elm"
import OBSWebSocket from "obs-websocket-js"

const root = document.querySelector("main")
const app = Elm.Main.init({ node: root })

const obs = new OBSWebSocket()

function main() {
  obs
    .connect()
    .then(() => {
      app.ports.obsConnectionReceiver.send(true)
      sendInputList()
    })
    .catch(() => app.ports.obsConnectionReceiver.send(false))

  obs.on("ConnectionOpened", () => app.ports.obsConnectionReceiver.send(true))
  obs.on("ConnectionClosed", () => app.ports.obsConnectionReceiver.send(false))

  app.ports.getInputListMessage.subscribe(() => sendInputList())

  app.ports.setInputTextMessages.subscribe((inputs) => setInputsText(inputs))
}

async function sendInputList() {
  const data = await obs.call("GetInputList", {
    inputKind: "text_ft2_source_v2",
  })
  const list = await Promise.all(
    data.inputs.map(async (x) => {
      const settings = await obs.call("GetInputSettings", {
        inputName: x.inputName,
      })
      return { name: x.inputName, text: settings.inputSettings.text }
    })
  )
  console.log(list)
  app.ports.inputListReceiver.send(list)
}

function setInputsText(inputs) {
  inputs.forEach((input) => {
    obs
      .call("SetInputSettings", {
        inputName: input.name,
        inputSettings: { text: input.text },
      })
      .then(() => {
        console.log("sent")
        // app.ports.setInputTextReceiver.send(inputName, text)
      })
  })
}

main()
