db.restaurants.find();

db.restaurants.find({}, {_id: 0, restaurant_id: 1, name: 1, borough: 1, cuisine: 1});

db.restaurants.find({borough: {$in: ["Bronx"]}}).limit(5);

db.restaurants.find({
    $or: [{
        $and: [{cuisine: {$not: /American/}}, {cuisine: {$not: /Chinese/}}]
    }, {name: {$regex: /^Wil/}}]
}, {_id: 0, restaurant_id: 1, name: 1, borough: 1, cuisine: 1});

db.restaurants.aggregate([{$match: {name: /mon/}}, {
    $project: {
        name: 1,
        borough: 1,
        longitude: {$first: {$slice: ["$address.coord", 1, 1]}},
        attitude: {$first: {$slice: ["$address.coord", 0, 1]}},
        cuisine: 1,
        _id: 0
    }
}]);

db.restaurants.find({
    $or: [
        {borough: 'Staten Island'},
        {borough: 'Queens'},
        {borough: 'Bronx'},
        {borough: 'Brooklyn'}
    ]
}, {restaurant_id: 1, name: 1, borough: 1, cuisine: 1, _id: 0});
