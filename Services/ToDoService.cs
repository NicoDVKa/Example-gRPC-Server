using Grpc.Core;
using ToDoGrpc.Data;
using ToDoGrpc.Models;

namespace ToDoGrpc.Services
{
    public class ToDoService : TodoIt.TodoItBase
    {
        private readonly AppDbContext _context;

        public ToDoService(AppDbContext context)
        {
            _context = context;
        }

        public override async Task<CreateToDoResponse> CreateToDo(CreateToDoRequest request, ServerCallContext context)
        {
            if (request.Title == string.Empty || request.Description == string.Empty)
                throw new RpcException(new Status(StatusCode.InvalidArgument, "You must supply a valid object"));

            var toDoItem = new ToDoItem
            {
                Title = request.Title,
                Description = request.Description,
            };

            await _context.ToDoItems.AddAsync(toDoItem);
            await _context.SaveChangesAsync();

            return await Task.FromResult(new CreateToDoResponse
            {
                Id = toDoItem.Id
            });
        }
    }
}
