defmodule SmartCellFileEditor do
  use Kino.JS
  use Kino.JS.Live
  use Kino.SmartCell, name: "File editor"

  @impl true
  def init(attrs, ctx) do
    {
      :ok,
      assign(
        ctx,
        file_content: attrs["file_content"] || "",
        filepath: attrs["filepath"] || ""
      )
    }
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, %{file_content: ctx.assigns.file_content, filepath: ctx.assigns.filepath}, ctx}
  end

  @impl true
  def handle_event("load_file", %{"filepath" => filepath}, ctx) do
    case File.read(filepath) do
      {:ok, content} ->
        broadcast_event(ctx, "fileLoaded", %{"file_content" => content})
        {:noreply, assign(ctx, file_content: content, filepath: filepath)}
      {:error, err} ->
        broadcast_event(ctx, "fileLoaded", %{"error" => inspect(err)})
        {:noreply, ctx}
    end
  end

  @impl true
  def handle_event("save_file", %{"filepath" => filepath, "file_content" => file_content}, ctx) do
    case File.write(filepath, file_content) do
      :ok ->
        broadcast_event(ctx, "fileWrite", %{"file_content" => file_content})
        {:noreply, assign(ctx, file_content: file_content)}
      {:error, err} ->
        broadcast_event(ctx, "fileWrite", %{"error" => inspect(err)})
        {:noreply, ctx}
    end
  end

  @impl true
  def to_attrs(ctx) do
    %{"file_content" => ctx.assigns.file_content, filepath: ctx.assigns.filepath}
  end

  @impl true
  def to_source(attrs) do
    quote do
      unquote(attrs["file_content"])
      |> IO.puts()
    end
    |> Kino.SmartCell.quoted_to_string()
  end

  asset "main.js" do
    """
    export function init(ctx, payload) {
      ctx.importCSS("main.css");

      ctx.root.innerHTML = `
        <div class="fileEditorWidget">
        <input id="filepath" type="text"></input><button id="loadButton">Load</button>
        <textarea id="file_content"></textarea>
        <button id="saveButton">Save</button>
        </div>
      `;

      const textarea = ctx.root.querySelector("#file_content");
      const filepath = ctx.root.querySelector("#filepath");
      const loadButton = ctx.root.querySelector("#loadButton");
      const saveButton = ctx.root.querySelector("#saveButton");
      filepath.value = payload.filepath;
      textarea.value = payload.file_content;

      loadButton.addEventListener("click", (event) => {
        ctx.pushEvent("load_file", { filepath: filepath.value });
      });

      saveButton.addEventListener("click", (event) => {
        ctx.pushEvent(
          "save_file",
          {
            filepath: filepath.value,
            file_content: textarea.value
          }
        );
      });

      ctx.handleEvent("fileLoaded", (payload) => {
        if (payload.error) {
          alert("Failed to load file");
        } else {
          textarea.value = payload.file_content;
        }
      });

      ctx.handleEvent("fileWrite", (payload) => {
        if (payload.error) {
          console.log(payload.error);
          alert("Failed to write file");
        } else {
          alert("file saved");
          textarea.value = payload.file_content;
        }
      });

      ctx.handleSync(() => {
        // Synchronously invokes change listeners
        document.activeElement &&
          document.activeElement.dispatchEvent(new Event("change"));
      });
    }
    """
  end

  asset "main.css" do
    """
    .fileEditorWidget {
      width: 100%;
      padding: 1rem;
      display: contents;  
    }

    #loadButton {
      margin-left: 0.5rem;      
    }

    #file_content {
      margin-top: 1rem;
      box-sizing: border-box;
      min-height: 18rem;
    }

    #saveButton {
      margin-top: 1rem;
    }

    input {
      padding: 0 8px;
      vertical-align: middle;
      border-radius: 2px;
      min-height: 36px;
      background-color: #ffffff;
      border: 1px solid rgba(36,28,21,0.3);
      transition: all 0.2s ease-in-out 0s;
      font-size: 16px;
      line-height: 18px;
      font-weight: normal;        
    }

    input:focus {
      outline: none;
      border: 1px solid #007c89;
      box-shadow: inset 0 0 0 1px #007c89;
    }

    textarea {
      width: 98%;
      padding: 0 8px;
      vertical-align: middle;
      border-radius: 2px;
      min-height: 36px;
      background-color: #ffffff;
      border: 1px solid rgba(36,28,21,0.3);
      transition: all 0.2s ease-in-out 0s;
      font-size: 16px;
      line-height: 18px;
      font-weight: normal;        
    }

    textarea:focus {
      outline: none;
      border: 1px solid #007c89;
      box-shadow: inset 0 0 0 1px #007c89;
    }

    button {
      display: inline-block;
      outline: none;
      cursor: pointer;
      font-weight: 500;
      border: 1px solid transparent;
      border-radius: 2px;
      height: 36px;
      line-height: 34px;
      font-size: 14px;
      color: #ffffff;
      background-color: #007c89;
      transition: background-color 0.2s ease-in-out 0s, opacity 0.2s ease-in-out 0s;
      padding: 0 18px;
    }

    button:hover {
      color: #ffffff;
      background-color: #006570;
    }
    """
  end
end