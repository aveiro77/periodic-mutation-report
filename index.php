<?php
$dbhost = "localhost";
$dbname = "test";
$dbuser = "root";
$dbpass = "";
$connection = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);

if (mysqli_connect_errno()) {
    echo "Database connection failed : " . mysqli_connect_error();
}

if((isset($_GET['start']) && isset($_GET['end'])) && ($_GET['start'] < $_GET['end'])){
    mysqli_query($connection, "call test.proc_mutation('" . $_GET['start'] . "','" . $_GET['end'] . "')");
    $data = mysqli_query($connection, "SELECT * FROM test.vmutation");
}else {
    $data = mysqli_query($connection, "SELECT * FROM test.vmutation WHERE item_id = 0");
}

$transaction = mysqli_query($connection, "SELECT a.*, b.name FROM test.tb_trans a LEFT JOIN test.tb_items b ON a.item_id=b.id");
$opening = mysqli_query($connection, "SELECT a.*, b.name FROM test.tb_opening_balance a LEFT JOIN test.tb_items b ON a.item_id=b.id");

?>

<!doctype html>
<html lang="en">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

    <title>Demo</title>
</head>

<body>
    <div class="container p-5">
        <h1 class="mb-2">Mutation by Period</h1>
        <hr>
        <div class="row">
            <div class="col-8">
                <form action="index.php" method="get" class="bg-warning p-3">
                    <div class="row">
                        <div class="col-4">
                            <div class="mb-3">
                                <label for="start" class="form-label">Start Period</label>
                                <input type="date" name="start" class="form-control form-control-sm" id="start">
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="mb-3">
                                <label for="end" class="form-label">End Period</label>
                                <input type="date" name="end" class="form-control form-control-sm" id="end">
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="mb-3">
                                <button type="submit" class="btn btn-danger mt-4">Execute</button>
                            </div>
                        </div>
                    </div>
                </form>
        <?php if (isset($_GET['start']) && isset($_GET['end'])) { ?>
            <p>Period <strong class="text-danger"><?= date('d F Y', strtotime($_GET['start'])); ?></strong> to <strong class="text-danger"><?= date('d F Y', strtotime($_GET['end'])); ?></strong></p>
        <?php } ?>
            </div>
        </div>

        <table class="table table-sm table-bordered table-hover">
            <thead>
                <tr>
                    <th scope="col">Item ID</th>
                    <th scope="col">Name</th>
                    <th scope="col">Unit</th>
                    <th scope="col">Opening QTY</th>
                    <th scope="col">In QTY</th>
                    <th scope="col">Out QTY</th>
                    <th scope="col">Ending QTY</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($data as $d) : ?>
                    <tr>
                        <th scope="row"><?= $d['item_id'] ?></th>
                        <td><?= $d['item_name'] ?></td>
                        <td><?= $d['item_unit'] ?></td>
                        <td align="right"><?= number_format($d['opening_balance'], 2, ',', '.') ?></td>
                        <td align="right"><?= number_format($d['qty_in'], 2, ',', '.') ?></td>
                        <td align="right"><?= number_format($d['qty_out'], 2, ',', '.') ?></td>
                        <td align="right"><?= number_format($d['qty_ending'], 2, ',', '.') ?></td>
                    </tr>
                <?php endforeach;  ?>
            </tbody>
        </table>
        <hr class="my-5">
        <div class="row">
            <div class="col-6">
                <div class="accordion" id="accordionPanelsStayOpenExample">
                    <div class="accordion-item bg-info">
                        <h2 class="accordion-header" id="panelsStayOpen-headingOne">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseOne" aria-expanded="false" aria-controls="panelsStayOpen-collapseOne">
                                <strong>Transaction Table</strong>
                            </button>
                        </h2>
                        <div id="panelsStayOpen-collapseOne" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingOne">
                            <div class="accordion-body">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th scope="col">Date</th>
                                            <th scope="col">Item ID</th>
                                            <th scope="col">Name</th>
                                            <th scope="col">In QTY</th>
                                            <th scope="col">Out QTY</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach ($transaction as $trans) : ?>
                                            <tr>
                                                <td><?= date('d F Y', strtotime($trans['date'])); ?></td>
                                                <td><?= $trans['item_id']; ?></td>
                                                <td><?= $trans['name']; ?></td>
                                                <td align="right"><?= $trans['qty_in']; ?></td>
                                                <td align="right"><?= $trans['qty_out']; ?></td>
                                            </tr>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-6">
                <div class="accordion" id="accordionPanelsStayOpenExample">
                    <div class="accordion-item bg-info">
                        <h2 class="accordion-header" id="panelsStayOpen-headingTwo">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseTwo" aria-expanded="false" aria-controls="panelsStayOpen-collapseTwo">
                                <strong>Opening Balance Table</strong>
                            </button>
                        </h2>
                        <div id="panelsStayOpen-collapseTwo" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingTwo">
                            <div class="accordion-body">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th scope="col">Item ID</th>
                                            <th scope="col">Name</th>
                                            <th scope="col">Year</th>
                                            <th scope="col">QTY</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach ($opening as $op) : ?>
                                            <tr>
                                                <td><?= $op['item_id']; ?></td>
                                                <td><?= $op['name']; ?></td>
                                                <td><?= $op['year']; ?></td>
                                                <td align="right"><?= $op['qty']; ?></td>
                                            </tr>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Optional JavaScript; choose one of the two! -->

    <!-- Option 1: Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</body>

</html>