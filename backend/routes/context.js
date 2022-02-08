const express = require('express');

const Active = require('../models/active')
const Notification = require('../models/notification');
const Restaurant = require('../models/restaurant')
const User = require('../models/user')
const Delivery = require('../models/delivery');
const user = require('../models/user');

const router = express.Router()

router.get('/:datetime', (req, res) => {
    let index = Date.parse(req.body.datetime)
    let contextMap = req.app.get('contextMap')

    if((typeof  contextMap.get(req.user.brand)) == 'undefined'){
        res.status(200).json({updates: []})
    }
    else{
        if(index < contextMap.get(req.user.brand).firstIndex){
            res.status(404).json({error: 'Index older than server first entrance'})
        }
        else{
            let stack = contextMap.get(req.user.brand).stack
            if((typeof stack) == 'undefined'){
                res.status(200).json({updates: []})
            }
            else{
                let element = stack.pop()
                let result = []
                let done = false
                while(!done){
                    if(index < element){
                        done = true
                        res.status(200).json({updates: result})
                    }
                    result.push(element.content)
                    element = stack.pop()
                }
            }
        }
    }
});

router.get('/new', (req, res) => {
    let usersReady = false
    let userList = []
    let deliveryList
    let notificationList
    let restaurantList

    //get users
    Active.find({brand: req.user.brand, finishTime: { $exists: false }})
        .then( actives => {
            if(actives.length > 0) {
                let count = 0;
                actives.forEach(active => {
                    User.findOne({_id: active.user})
                        .then( user => {
                            userList.push({
                                name: user.name,
                                email: user.email,
                                phone: user.phone,
                                restaurant: user.restaurant,
                                latitude: user.latitude,
                                longitude: user.longitude,
                                time: user.time
                            })
                        })
                    count++;
                });
                if(count == (actives.length - 1)) {
                    usersReady = true
                }
            }
            else{
                usersReady = true
            }
        })
        .catch(error => {
            res.status(500).json(error)
        })
        .finally(sendData)

    //get deliveries
    Delivery.find({brand: req.user.brand})
        .then(deliveries => {
            if(!deliveries) { deliveryList = [] }
            else{ deliveryList = deliveries }
        })
        .catch(error => {
            res.status(500).json(error)
        })
        .finally(sendData)

    //get add requests
    if(req.user.privilege){
        Notification.find({brand: req.user.brand, type: 'add-request'})
            .then(notifications => {
                if(!notifications){ notificationList = [] }
                else{ notificationList = notifications }
            })
            .catch(error => {
                res.status(500).json(error)
            })
            .finally(sendData)
    }else{
        notificationList = []
        sendData()
    }

    //get restaurants
    Restaurant.find({brand: req.user.brand})
        .then(restaurants => {
            if(!restaurants){ restaurantList = [] }
            else { restaurantList = restaurants }
        })
        .finally(sendData)

    //send data
    function sendData(){
        if(usersReady 
            && deliveryList 
            && notificationList 
            && restaurantList)
        {
            res.status(200).json({
                users: userList,
                deliveries: deliveryList,
                notifications: notificationList,
                restaurants: restaurantList
            })
        }
    }
});

module.exports = router