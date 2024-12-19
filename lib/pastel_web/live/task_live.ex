defmodule PastelWeb.TaskLive do
  use PastelWeb, :live_view

  alias Pastel.Todo
  alias Pastel.Todo.Task

  def render(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <header class="px-6 pt-12 pb-4">
        <div class="flex flex-row justify-between items-center gap-x-2">
          <div class="basis-0 grow">
            <.link
              class="flex justify-center items-center bg-gray-200 size-10 rounded-full"
              patch={~p"/"}
            >
              <.icon name="hero-chevron-left" class="size-6" />
            </.link>
          </div>

          <div>
            <p class="text-lg font-semibold">Create task</p>
          </div>

          <div class="basis-0 grow"></div>
        </div>
      </header>

      <main class="grow overflow-y-auto p-4">
        <.form for={@form} phx-submit="save" class="flex flex-col gap-y-4">
          <.input
            type="text"
            field={@form[:name]}
            label="Task name"
            placeholder="Enter task title"
            icon="hero-clipboard"
          />
          <.input
            type="textarea"
            field={@form[:description]}
            label="Task description"
            placeholder="Enter task description"
          />
        </.form>
      </main>

      <footer class="p-4 bg-white">
        <button class="bg-indigo-950 p-4 rounded-full w-full text-white flex justify-center items-center gap-x-2">
          <span class="text-lg">Create task</span>
          <.icon name="hero-plus" class="size-5" />
        </button>
      </footer>
    </div>
    """
  end

  def handle_params(_params, _uri, socket) do
    task = %Task{}
    changeset = Todo.change_task(task)

    socket =
      socket
      |> assign(:task, task)
      |> assign_form(changeset)

    {:noreply, socket}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
