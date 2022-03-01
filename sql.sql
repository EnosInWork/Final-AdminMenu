CREATE TABLE `warn` (
  `id` int(11) NOT NULL,
  `author` text NOT NULL,
  `date` text NOT NULL,
  `firstname` text NOT NULL,
  `lastname` text NOT NULL,
  `steam` text NOT NULL,
  `reason` text NOT NULL,
  `warnnumero` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `warn`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `warn`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;