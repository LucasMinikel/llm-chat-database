<?php

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    $flaskUrl = env('FLASK_SERVICE_URL', 'http://flask:5000');
    $response = Http::get($flaskUrl);
    return view(
        'welcome',
        [
            'status' => $response->json()['status']
        ]
    );
});
