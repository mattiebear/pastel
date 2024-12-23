defmodule PastelWeb.TasksLive do
  use PastelWeb, :live_view

  alias Pastel.Todo

  def render(assigns) do
    ~H"""
    <div class="h-full flex flex-col bg-gradient-to-b from-white to-gray-100">
      <header class="px-6 pt-12 pb-4">
        <div class="flex flex-row items-center gap-x-2">
          <div class="size-10 rounded-full overflow-hidden">
            <img src="https://i.pravatar.cc/300?u=a042581f4e29026704d" alt="The avatar for the user" />
          </div>

          <div>
            <p class="text-lg font-semibold">My tasks</p>
            <p class="text-sm text-gray-500">{@current_user.email}</p>
          </div>

          <div class="grow"></div>

          <button class="bg-gray-200 size-10 rounded-full">
            <.icon name="hero-bell" class="size-6" />
          </button>
        </div>
      </header>

      <main class="grow overflow-y-auto">
        <div class="flex flex-col gap-y-4 px-4 pb-8 pt-4">
          <div :for={task <- @tasks} class="rounded-xl p-3 bg-blue-200">
            <h2 class="text-xl font-semibold mb-8">{task.name}</h2>
            <div class="flex flex-row">
              <div class="pl-3 pr-4 py-1.5 text-sm rounded-full flex flex-row items-center bg-gray-400/25">
                <.icon class="size-4 mr-3" name="hero-calendar" />
                <span class="text-sm">{PastelWeb.Date.format_short(task.due_on)}</span>
              </div>
            </div>
          </div>
        </div>
      </main>

      <footer class="p-4 bg-white">
        <div class="flex flex-row justify-center items-center relative">
          <.link
            class="flex justify-center items-center size-12 rounded-full bg-indigo-950 absolute -bottom-3"
            patch={~p"/tasks/new"}
          >
            <.icon name="hero-plus" class="size-6 text-white" />
          </.link>
        </div>

        <nav class="flex flex-row justify-between">
          <button class="flex flex-col items-center gap-y-1 p-2 basis-20">
            <.icon name="hero-home" class="size-6" />
            <span class="text-xs">Home</span>
          </button>

          <button class="flex flex-col items-center gap-y-1 p-2 basis-20">
            <.icon name="hero-check-circle" class="size-6" />
            <span class="text-xs">Tasks</span>
          </button>

          <div></div>

          <button class="flex flex-col items-center gap-y-1 p-2 basis-20">
            <.icon name="hero-chat-bubble-oval-left" class="size-6" />
            <span class="text-xs">Messages</span>
          </button>

          <button class="flex flex-col items-center gap-y-1 p-2 basis-20">
            <.icon name="hero-user-circle" class="size-6" />
            <span class="text-xs">Account</span>
          </button>
        </nav>
      </footer>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    tasks = Todo.list_tasks(socket.assigns.current_user)
    {:ok, assign(socket, tasks: tasks)}
  end
end
