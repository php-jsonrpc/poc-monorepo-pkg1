<?php
namespace PhpJsonrpc\PocMonorepoPkg1\Model;

use Psr\Log\LoggerInterface;
use Psr\Log\NullLogger;

class Dummy
{
    private LoggerInterface $logger;

    public function __construct(
        LoggerInterface $logger = null
    ) {
        $this->logger = $logger ?? new NullLogger();
    }

    public function getLogger(): LoggerInterface
    {
        return $this->logger;
    }
}
