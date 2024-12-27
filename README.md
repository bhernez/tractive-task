# Tractive Task

## Features

- CRUD operations for pets.
- In-memory storage for entities (with methods very alike to ActiveRecord).
- Simple stats endpoint to retrieve the number of pets within the power saving zone.

## Be aware

- The data is currently stored in memory and will be lost when the server is restarted
  either manually or automatically (ex: when a file is changed).

## Requirements

- Ruby 3.3.6
- Bundler 2.x or higher

## Installation

To set up the project on your local machine:

1. Clone the repository:
   ```bash
   git clone https://github.com/bhernez/tractive-task.git
   cd tractive-task
    ```
2. Install dependencies:
    ```bash
    bundle install
    ```

3. Run the application:
    ```bash
    rails server
    ```
The application will load some sample data to work with after starting the server.
This data can be found in `config/initializers/load_sample_data.rb`.

## Usage

To use the application:

### Create a Pet (POST)

Add a new pet.

```bash
curl -X POST http://localhost:3000/pets \
     -H "Content-Type: application/json" \
     -d '{
           "pet": {
             "type": "Dog",
             "tracker_type": "small",
             "owner_id": 1,
             "in_zone": true
           }
         }'
```

### Create a Cat (POST)

Add a new cat with specific attributes.

```bash
curl -X POST http://localhost:3000/pets \
     -H "Content-Type: application/json" \
     -d '{
           "pet": {
             "type": "Cat",
             "tracker_type": "small",
             "owner_id": 1,
             "in_zone": true,
             "lost_tracker": false
           }
         }'
```

### List Pets (GET)

Retrieve a list of all pets.

```bash
curl -X GET http://localhost:3000/pets?type=dog -H "Content-Type: application/json"
```
Allowed query parameters:

- `in_zone`: Filter pets by zone status. (Optional `true` or `false`)
- `lost_tracker`: Filter pets by lost tracker status. (Optional `true` or `false`, only accepted when `type` is `Cat`)
- `owner_id`: Filter pets by owner ID (Optional integer).
- `tracker_type`: Filter pets by tracker type. (Optional `small`, `medium`, or `big`).
- `type`: Filter pets by type (Required: `Dog` or `Cat`).

### Update a Pet (PUT/PATCH)

Update a specific pet's attributes.

```bash
curl -X PATCH http://localhost:3000/pets/1 \
     -H "Content-Type: application/json" \
     -d '{
           "pet": {
             "tracker_type": "big",
             "in_zone": false
           }
         }'
```
Allowed parameters:

- `in_zone`: Filter pets by zone status. (`true` or `false`)
- `lost_tracker`: Filter pets by lost tracker status. (`true` or `false`, only accepted when `type` is `Cat`)
- `tracker_type`: Filter pets by tracker type. (`small`, `medium`*, or `big`, `medium` only accepted when `type` is `Dog`).

### Delete a Pet (DELETE)

Remove a specific pet by ID.

```bash
curl -X DELETE http://localhost:3000/pets/1 -H "Content-Type: application/json"
```

### Show basic stats (GET)

Retrieve the number of pets within the power saving zone.

```bash
curl -X GET http://localhost:3000/pets/stats -H "Content-Type: application/json"
```
Expected response:
```json
{
   "total": 2,
   "in_zone":{
      "true":{
         "Dog":{ "small": 1 },
         "Cat":{ "big": 1 }
      }
   }
}
```

## Testing

To run the test suite:

```bash
rails test
```
