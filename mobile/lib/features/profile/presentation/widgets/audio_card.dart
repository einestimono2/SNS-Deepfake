import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/utils/utils.dart';

class AudioCard extends StatefulWidget {
  final String url;
  final bool isFile;
  final bool isNetwork;
  final Function(String)? onDelete;

  const AudioCard({
    super.key,
    required this.url,
    this.isFile = true,
    this.isNetwork = false,
    this.onDelete,
  });

  @override
  State<AudioCard> createState() => _AudioCardState();
}

class _AudioCardState extends State<AudioCard> {
  final player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _initPlayer();
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  void _initPlayer() {
    String prefix = widget.isNetwork
        ? ""
        : widget.isFile
            ? "file:"
            : "asset:";
    player.setUrl("$prefix${widget.url}");

    player.positionStream.listen((p) => setState(() {
          if (mounted) {
            _position = p;
          }
        }));

    player.durationStream.listen((p) => p == null
        ? null
        : setState(() {
            if (mounted) {
              _duration = p;
            }
          }));

    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          if (mounted) {
            _position = Duration.zero;
          }
        });

        player.pause();
        player.seek(_position);
      }
    });
  }

  String format(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void _handleAction() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }

    setState(() {
      if (mounted) {}
    });
  }

  void _handleSeek(double value) {
    player.seek(Duration(seconds: value.round()));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: AppColors.kPrimaryColor.withOpacity(0.5),
          ),
          onPressed: _handleAction,
          icon: Icon(player.playing ? Icons.pause : Icons.play_arrow),
        ),

        /*  */
        Expanded(
          child: Column(
            children: [
              Slider(
                min: 0.0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds.toDouble(),
                onChanged: _handleSeek,
                inactiveColor: Colors.grey.shade300,
                activeColor: AppColors.kPrimaryColor.withOpacity(0.75),
                thumbColor: AppColors.kPrimaryColor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      format(_position),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      format(_duration),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /*  */
        if (widget.onDelete != null)
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.redAccent.shade200,
            ),
            onPressed: () {
              player.stop();
              widget.onDelete!(widget.url);
            },
            icon: const Icon(Icons.delete, size: 22),
          ),
      ],
    );
  }
}
