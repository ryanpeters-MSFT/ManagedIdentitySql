using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

var builder = WebApplication.CreateBuilder(args);

var app = builder.Build();

var configuration = app.Services.GetService<IConfiguration>();

var connectionString = configuration.GetConnectionString("AzureSql");

app.MapGet("/hello", () =>
{
    var names = new List<object>();

    try
    {
        using (var connection = new SqlConnection(connectionString))
        {
            connection.Open();

            using var command = new SqlCommand("select * from Client", connection);
            using var reader = command.ExecuteReader();

            while (reader.Read())
            {
                names.Add(new
                {
                    name = reader["Name"].ToString(),
                    age = Convert.ToInt16(reader["Age"])
                });
            }
        }

        return Results.Ok(names);
    }
    catch (Exception ex)
    {
        return Results.Content(ex.ToString());
    }
});

app.Run();