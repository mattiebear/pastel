defmodule PastelWeb.TaskLive do
  use PastelWeb, :live_view

  alias Pastel.Todo.Task

  def render(assigns) do
    ~H"""
    <header class="px-6 py-12">
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
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    task = %Task{}
    changeset = Task.changeset(task, %{})

    socket =
      socket
      |> assign(:task, task)
      |> assign_form(changeset)

    {:noreply, socket}
  end

  defp assign_form(socket, changeset) do
    assign(socket, form: to_form(changeset))
  end
end
