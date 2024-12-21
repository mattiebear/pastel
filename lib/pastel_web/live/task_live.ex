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
        <.form
          for={@form}
          phx-change="validate"
          phx-submit="save"
          id="task_form"
          class="flex flex-col gap-y-4"
        >
          <.input
            type="text"
            field={@form[:name]}
            label="Task name"
            placeholder="Enter task title"
            icon="hero-clipboard"
            phx-debounce="blur"
          />

          <% # FIXME: get auto resize this to work %>

          <.input
            type="textarea"
            field={@form[:description]}
            label="Task description"
            placeholder="Enter task description"
            phx-hook="AutoResizeTextarea"
            phx-debounce="blur"
          />

          <div class="flex flex-row items-center">
            <.label>Due date</.label>

            <fieldset class="flex flex-row items-center px-6 gap-x-2">
              <label
                for="due_today"
                class={[
                  "cursor-pointer px-4 py-1.5 text-sm bg-gray-200 rounded-full transition-colors",
                  @form[:relative_due_date].value == "today" && "bg-rose-400 text-white"
                ]}
                ]}
              >
                <input
                  id="due_today"
                  type="radio"
                  name="task[relative_due_date]"
                  value="today"
                  class="hidden"
                  checked={@form[:relative_due_date].value == "today"}
                />
                <span class="whitespace-nowrap font-semibold transition-colors">Today</span>
              </label>

              <label
                for="due_week"
                class={[
                  "cursor-pointer px-4 py-1.5 text-sm bg-gray-200 rounded-full transition-colors",
                  @form[:relative_due_date].value == "this_week" && "bg-rose-400 text-white"
                ]}
              >
                <input
                  id="due_week"
                  type="radio"
                  name="task[relative_due_date]"
                  value="this_week"
                  class="hidden"
                  checked={@form[:relative_due_date].value == "this_week"}
                />
                <span class="whitespace-nowrap font-semibold transition-colors">This week</span>
              </label>

              <label
                for="due_later"
                class={[
                  "cursor-pointer px-4 py-1.5 text-sm bg-gray-200 rounded-full transition-colors",
                  @form[:relative_due_date].value == "later" && "bg-rose-400 text-white"
                ]}
              >
                <input
                  id="due_later"
                  type="radio"
                  name="task[relative_due_date]"
                  value="later"
                  class="hidden"
                  checked={@form[:relative_due_date].value == "later"}
                />
                <span class="whitespace-nowrap font-semibold transition-colors">Later</span>
              </label>
            </fieldset>
          </div>
          <.button type="button" phx-click={open_drawer("task_drawer")}>Open drawer</.button>
        </.form>
      </main>

      <footer class="p-4 bg-white">
        <button
          class="bg-indigo-950 p-4 rounded-full w-full text-white flex justify-center items-center gap-x-2"
          phx-click={JS.dispatch("submit", to: "#task_form")}
        >
          <span class="text-lg">Create task</span>
          <.icon name="hero-plus" class="size-5" />
        </button>
      </footer>
    </div>

    <.drawer id="task_drawer">
      The drawer
    </.drawer>
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

  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset =
      Todo.change_task(socket.assigns.task, task_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  # TODO: Save the task
  def handle_event("save", %{"task" => task_params}, socket) do
    case Todo.create_task(socket.assigns.current_user, task_params) do
      {:ok, _task} ->
        {:noreply, redirect(socket, to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
